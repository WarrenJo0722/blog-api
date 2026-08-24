package org.example.blogapi.controller;

import lombok.RequiredArgsConstructor;
import org.example.blogapi.dto.PostRequest;
import org.example.blogapi.dto.PostResponse;
import org.example.blogapi.entity.Post;
import org.example.blogapi.repository.PostRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostRepository postRepository;

    @GetMapping
    public List<PostResponse> getAllPosts() {
        return postRepository.findAll().stream()
            .map(PostResponse::from)
            .collect(Collectors.toList());
    }

    @PostMapping
    public ResponseEntity<PostResponse> createPost(@RequestBody PostRequest request) {
        Post post = new Post();
        post.setTitle(request.getTitle());
        post.setContent(request.getContent());
        post.setAuthor(request.getAuthor());

        Post saved = postRepository.save(post);
        return ResponseEntity.ok(PostResponse.from(saved));
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("OK");
    }
}