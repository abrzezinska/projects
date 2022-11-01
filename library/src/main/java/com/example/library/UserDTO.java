package com.example.library;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.annotation.processing.Generated;
import javax.persistence.Entity;
import javax.persistence.Id;

@AllArgsConstructor
public class UserDTO {
    public String login;
    @Getter
    public String password;

    public UserDTO(){

    }
}
