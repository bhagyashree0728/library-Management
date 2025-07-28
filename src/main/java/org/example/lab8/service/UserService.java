package org.example.lab8.service;

import org.example.lab8.model.User;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.io.*;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Service
public class UserService {
    private static final String USERS_FILE = "users.json";
    private final Gson gson = new Gson();
    private final List<User> users = new ArrayList<>();

    public UserService() {
        List<User> loaded = loadUsersFromFile();
        if (loaded.isEmpty()) {
            users.add(new User("admin", "admin", "ADMIN"));
            saveUsersToFile();
        } else {
            users.addAll(loaded);
        }
    }

    private List<User> loadUsersFromFile() {
        try (Reader reader = new FileReader(USERS_FILE)) {
            return gson.fromJson(reader, new TypeToken<List<User>>(){}.getType());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private void saveUsersToFile() {
        try (Writer writer = new FileWriter(USERS_FILE)) {
            gson.toJson(users, writer);
        } catch (Exception e) {
            // log error
        }
    }

    public boolean authenticate(User user) {
        return users.stream().anyMatch(u ->
            u.getUsername().equals(user.getUsername()) &&
            u.getPassword().equals(user.getPassword())
        );
    }

    public boolean register(User user) {
        if (users.stream().anyMatch(u -> u.getUsername().equals(user.getUsername()))) {
            return false; // Username already exists
        }
        users.add(user);
        saveUsersToFile();
        return true;
    }

    public User findByUsername(String username) {
        return users.stream().filter(u -> u.getUsername().equals(username)).findFirst().orElse(null);
    }

    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }

    public boolean updateUser(User updatedUser) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUsername().equals(updatedUser.getUsername())) {
                users.set(i, updatedUser);
                saveUsersToFile();
                return true;
            }
        }
        return false;
    }

    public boolean deleteUser(String username) {
        boolean removed = users.removeIf(u -> u.getUsername().equals(username));
        if (removed) saveUsersToFile();
        return removed;
    }
} 