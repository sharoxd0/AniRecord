package com.cognixia.jump.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.cognixia.jump.model.Anime;
import com.cognixia.jump.repository.AnimeRepository;

@RequestMapping("/api")
@RestController
public class AnimeController {

	@Autowired
	AnimeRepository service;
	
	@GetMapping("/anime")
	public List<Anime> getAllAnime() {
		return service.findAll();
	}
	
	@GetMapping("/anime/{id}")
	public Anime getAnime(@PathVariable long id) {
		Optional<Anime> anime = service.findById(id);
		
		if(anime.isPresent()) {
			return anime.get();
		}
		
		return new Anime();
	}
	
	@DeleteMapping("/delete/anime/{id}")
	public ResponseEntity<String> deleteAnime(@PathVariable long id) {
		
		Optional<Anime> found = service.findById(id);
		
		if(found.isPresent()) {
			service.deleteById(id);
			
			return ResponseEntity.status(200).body("Anime has been deleted");
			
		}else {
			return ResponseEntity.status(400).header("anime id", id + "").body("Anime not found");
		}
	}
	
	
	@PostMapping("/add/anime")
	public void addAnime(@RequestBody Anime newAnime) {
		
		newAnime.setId(-1L);
		
		Anime added = service.save(newAnime);
		
		System.out.println("Added: " + added);
		
	}
	
	@PutMapping("/update/anime")
	public @ResponseBody String updateAnime(@RequestBody Anime updateAnime) {
		
		Optional<Anime> found = service.findById(updateAnime.getId());
		
		if(found.isPresent()) {
			service.save(updateAnime);
			return "Saved: " + updateAnime.toString();
		}else {
			return "Could not update student";
		}
		
	}
}
