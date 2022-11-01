package com.example.library;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@NoArgsConstructor
@Entity(name="userEntity")
@AllArgsConstructor
@Setter
@Getter
public class UserEntity {
    @Id
    public String ID;
    public String login;
    public String password;
    public String name;
    public String surname;
    @ManyToMany(
            cascade = {CascadeType.MERGE, CascadeType.PERSIST}
    )

    @JoinTable(
            name = "libraryEntity",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "book_id")
    )
    private Set<BookEntity>bookEntity = new HashSet<>();
}

