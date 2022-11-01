package com.example.library;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import java.util.HashSet;
import java.util.Set;

@NoArgsConstructor
@Entity(name="bookEntity")
@AllArgsConstructor
@Setter
@Getter
public class BookEntity{
    @Id
    public String book_ID;
    public String book_name;
    public int book_amount;
    public String book_author;
    @ManyToMany(mappedBy = "bookEntity")
    private Set<UserEntity> userEntity  = new HashSet<>();
}
