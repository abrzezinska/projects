package com.example.library;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository <UserEntity, String>{
    Optional<UserEntity> findByLogin(String s);
}
