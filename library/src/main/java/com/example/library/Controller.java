package com.example.library;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class Controller {
    @Autowired
    public Serwis serwis;
    @PostMapping("/register")
    public boolean register(@RequestBody UserEntity user){
        return serwis.register(user);

    }
    @PostMapping("/login")
    public boolean login(@RequestBody UserDTO user){
        return serwis.login(user);

    }
    @GetMapping()
    public List getAll(){
        return serwis.getAll();
    }
    @PutMapping("/lend")
    public void lend(@RequestParam String login, @RequestParam String name){
         serwis.lend(login,name);
    }
    @PutMapping("/back")
    public void back(@RequestParam String login, @RequestParam String name){
        serwis.back(login,name);
    }
}
