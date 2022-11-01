package com.example.library;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class Serwis {
    @Autowired
   public  UserRepository userRepository;
    @Autowired
    public   BookRepository bookRepository;

    public List getAll(){
    List<BookEntity> books=    bookRepository.findAll();
        return books.stream().filter(e->e.book_amount>0).collect(Collectors.toList());

    }
    public void lend(String login, String bookName){
        List<BookEntity> books=    bookRepository.findAll();
      Optional<BookEntity> bookEntity = books.stream().filter(e->e.book_name.equals(bookName)).findFirst();
        Optional<UserEntity> user = userRepository.findByLogin(login);
        if(user.isEmpty() || bookEntity.isEmpty()) return ;
        int i = bookEntity.get().book_amount;
        bookEntity.get().setBook_amount(i-1);
        Set list =bookEntity.get().getUserEntity();
        list.add(user.get());
        bookEntity.get().setUserEntity(list);
        bookRepository.save(bookEntity.get());
        Set bookEntitySet = user.get().getBookEntity();
        bookEntitySet.add(bookEntity.get());
        user.get().setBookEntity(bookEntitySet);
        userRepository.save(user.get());

    }
    public void back(String login, String bookName){
        List<BookEntity> books=    bookRepository.findAll();
        Optional<BookEntity> bookEntity = books.stream().filter(e->e.book_name.equals(bookName)).findFirst();
        Optional<UserEntity> user = userRepository.findByLogin(login);
        if(user.isEmpty() || bookEntity.isEmpty()) return ;
        int i = bookEntity.get().book_amount;
        bookEntity.get().setBook_amount(i+1);
        Set list =bookEntity.get().getUserEntity();
        list.remove(user.get());
        bookEntity.get().setUserEntity(list);
        bookRepository.save(bookEntity.get());
        Set bookEntitySet = user.get().getBookEntity();
        bookEntitySet.remove(bookEntity.get());
        user.get().setBookEntity(bookEntitySet);
        userRepository.save(user.get());

    }
    public boolean register( UserEntity user){
       if(!userRepository.findByLogin(user.login).isPresent()) userRepository.save(user);

        return true;
    }
    public boolean login( UserDTO userDTO){
        Optional<UserEntity> op=userRepository.findByLogin(userDTO.login);
if(op.isPresent() && userDTO.password!=null && userDTO.getPassword().equals(op.get().password))
{
    return true;
}
        return false;
    }
}
