using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace EliteTweet.AI
{
    public class ModerationResult
    {
        public bool Success { get; set; }

        public bool IsSafe { get; set; }

        public string Category { get; set; }

        public string Reason { get; set; }
    }

    public class ContentSafetyService
    {
        private const string Model = "gemini-3.5-flash-lite";

        private readonly HttpClient _httpClient;

        public ContentSafetyService()
        {
            _httpClient = new HttpClient();
        }

        public async Task<ModerationResult> CheckContentAsync(string content)
        {
            try
            {
                string apiKey =
                    Environment.GetEnvironmentVariable("GEMINI_API_KEY");

                if (string.IsNullOrEmpty(apiKey))
                {
                    return new ModerationResult
                    {
                        Success = false,
                        IsSafe = false,
                        Category = "System Error",
                        Reason = "Gemini API key was not found."
                    };
                }

                string url =
                    "https://generativelanguage.googleapis.com/v1beta/models/"
                    + Model
                    + ":generateContent?key="
                    + apiKey;

                string prompt = @"
You are the content safety moderation system for a social media application.

Analyze the following user-generated content.

Classify the content as SAFE or UNSAFE.

Possible unsafe categories are:

- Harassment
- Hate Speech
- Sexual Content
- Threat
- Dangerous Content
- Other

A normal opinion, criticism, disagreement, joke, or negative statement should NOT automatically be classified as unsafe.

Return ONLY valid JSON in this exact format:

{
  ""isSafe"": true,
  ""category"": ""Safe"",
  ""reason"": ""Content is safe.""
}

For unsafe content, return:

{
  ""isSafe"": false,
  ""category"": ""Threat"",
  ""reason"": ""Short explanation of why the content is unsafe.""
}

Choose the most appropriate category.

Content to analyze:

" + content;

                JObject requestBody = new JObject
                {
                    ["contents"] = new JArray
                    {
                        new JObject
                        {
                            ["parts"] = new JArray
                            {
                                new JObject
                                {
                                    ["text"] = prompt
                                }
                            }
                        }
                    },

                    ["generationConfig"] = new JObject
                    {
                        ["responseMimeType"] = "application/json",

                        ["responseSchema"] = new JObject
                        {
                            ["type"] = "OBJECT",

                            ["properties"] = new JObject
                            {
                                ["isSafe"] = new JObject
                                {
                                    ["type"] = "BOOLEAN"
                                },

                                ["category"] = new JObject
                                {
                                    ["type"] = "STRING"
                                },

                                ["reason"] = new JObject
                                {
                                    ["type"] = "STRING"
                                }
                            },

                            ["required"] = new JArray
                            {
                                "isSafe",
                                "category",
                                "reason"
                            }
                        }
                    }
                };

                StringContent requestContent =
                    new StringContent(
                        requestBody.ToString(),
                        Encoding.UTF8,
                        "application/json"
                    );

                HttpResponseMessage response =
                    await _httpClient.PostAsync(
                        url,
                        requestContent
                    );

                string responseText =
                    await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    return new ModerationResult
                    {
                        Success = false,
                        IsSafe = false,
                        Category = "System Error",
                        Reason = "Gemini API error: " + responseText
                    };
                }

                JObject jsonResponse =
                    JObject.Parse(responseText);

                string generatedText =
                    (string)jsonResponse["candidates"]?[0]
                    ?["content"]?["parts"]?[0]?["text"];

                if (string.IsNullOrEmpty(generatedText))
                {
                    return new ModerationResult
                    {
                        Success = false,
                        IsSafe = false,
                        Category = "System Error",
                        Reason = "Gemini returned an empty response."
                    };
                }

                generatedText = generatedText.Trim();

                JObject moderationJson =
                    JObject.Parse(generatedText);

                bool isSafe =
                    (bool?)moderationJson["isSafe"] ?? false;

                string category =
                    (string)moderationJson["category"]
                    ?? "Other";

                string reason =
                    (string)moderationJson["reason"]
                    ?? "No reason provided.";

                return new ModerationResult
                {
                    Success = true,
                    IsSafe = isSafe,
                    Category = category,
                    Reason = reason
                };
            }
            catch (Exception ex)
            {
                return new ModerationResult
                {
                    Success = false,
                    IsSafe = false,
                    Category = "System Error",
                    Reason = "Content safety check failed: "
                             + ex.Message
                };
            }
        }
    }
}