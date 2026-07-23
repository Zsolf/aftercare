package com.zsolf.aftercare.web.dto;

import java.util.Set;

public record UserResponse(String email, Set<String> roles) {
}
