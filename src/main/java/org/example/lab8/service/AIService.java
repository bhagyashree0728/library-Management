package org.example.lab8.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.example.lab8.model.Book;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@Service
public class AIService {
    private static final String DEFAULT_MODEL = "gemini-1.5-flash";
    private static final String API_BASE = "https://generativelanguage.googleapis.com/v1beta/models/";
    private final Gson gson = new Gson();

    private String getApiKey() {
        String key = System.getenv("GEMINI_API_KEY");
        if (key == null || key.isEmpty()) {
            throw new IllegalStateException("GEMINI_API_KEY environment variable is not set");
        }
        return key;
    }

    private String generateContent(String model, String prompt) throws IOException {
        String apiKey = getApiKey();
        String endpoint = API_BASE + model + ":generateContent?key=" + apiKey;
        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", prompt);
        JsonArray parts = new JsonArray();
        parts.add(textPart);
        JsonObject content = new JsonObject();
        content.addProperty("role", "user");
        content.add("parts", parts);
        JsonArray contents = new JsonArray();
        contents.add(content);
        JsonObject body = new JsonObject();
        body.add("contents", contents);

        String payload = gson.toJson(body);
        try (OutputStream os = conn.getOutputStream()) {
            os.write(payload.getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        BufferedReader reader = new BufferedReader(new InputStreamReader(
                status >= 400 ? conn.getErrorStream() : conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        conn.disconnect();

        if (status >= 400) {
            throw new IOException("Gemini API error (" + status + "): " + response);
        }

        return extractTextFromResponse(response.toString());
    }

    private String extractTextFromResponse(String json) {
        try {
            JsonObject root = gson.fromJson(json, JsonObject.class);
            JsonArray candidates = root.getAsJsonArray("candidates");
            if (candidates != null && candidates.size() > 0) {
                JsonObject candidate0 = candidates.get(0).getAsJsonObject();
                JsonObject content = candidate0.getAsJsonObject("content");
                if (content != null) {
                    JsonArray parts = content.getAsJsonArray("parts");
                    if (parts != null && parts.size() > 0) {
                        JsonElement firstPart = parts.get(0);
                        if (firstPart.isJsonObject() && firstPart.getAsJsonObject().has("text")) {
                            return firstPart.getAsJsonObject().get("text").getAsString();
                        }
                    }
                }
            }
        } catch (Exception ignored) {
        }
        return "No response text returned by the AI.";
    }

    public String generateBookSummary(Book book) throws IOException {
        String prompt = "Provide a concise, engaging summary for the following book in 5-7 sentences.\n" +
                "Title: " + safe(book.getTitle()) + "\n" +
                "Author: " + safe(book.getAuthor()) + "\n" +
                "ISBN: " + safe(book.getIsbn()) + "\n" +
                "If the exact book is unknown, infer a plausible summary based on the title and author, and clearly state that it is AI-generated.";
        return generateContent(DEFAULT_MODEL, prompt);
    }

    public String generateRecommendationsForBook(Book book) throws IOException {
        String prompt = "Recommend 5 similar books based on the following details. " +
                "Return as a short bulleted list with title and author, and a one-line reason.\n" +
                "Target Book: \n" +
                "- Title: " + safe(book.getTitle()) + "\n" +
                "- Author: " + safe(book.getAuthor()) + "\n" +
                "- ISBN: " + safe(book.getIsbn()) + "\n" +
                "Assume a general audience and avoid spoilers.";
        return generateContent(DEFAULT_MODEL, prompt);
    }

    public String generateRecommendationsByQuery(String query) throws IOException {
        String prompt = "Based on this user interest/query, recommend 5 books (title and author) with a one-line reason each. " +
                "Keep it concise and friendly. Query: " + safe(query);
        return generateContent(DEFAULT_MODEL, prompt);
    }

    private String safe(String v) {
        return v == null ? "" : v;
    }
}
