package com.cognixia.jump.model;

import java.io.Serializable;
import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Anime implements Serializable {

	private static final long serialVersionUID = 9207491617172507257L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@Column(unique = true, nullable = false)
	private String name;

	@Column
	private LocalDate releaseDate;

	@Column
	private String showImage;

	@Column(columnDefinition = "varchar(255) default 'Undecided'")
	private String description;

	@Column
	private int rating;

	@Column
	private String creator;

	@Column
	private String creatorImage;

	@Column(name = "main_character")
	private String protagonist;

	@Column
	private String protagImage;

	public Anime() {
		this(-1L, "N/A", LocalDate.now(), "N/A", "N/A", -1, "N/A", "N/A", "N/A", "N/A");
	}

	public Anime(Long id, String name, LocalDate releaseDate, String showImage, String description, int rating,
			String creator, String creatorImage, String protagonist, String protagImage) {
		super();
		this.id = id;
		this.name = name;
		this.releaseDate = releaseDate;
		this.showImage = showImage;
		this.description = description;
		this.rating = rating;
		this.creator = creator;
		this.creatorImage = creatorImage;
		this.protagonist = protagonist;
		this.protagImage = protagImage;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public LocalDate getReleaseDate() {
		return releaseDate;
	}

	public void setReleaseDate(LocalDate releaseDate) {
		this.releaseDate = releaseDate;
	}

	public String getShowImage() {
		return showImage;
	}

	public void setShowImage(String showImage) {
		this.showImage = showImage;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getCreatorImage() {
		return creatorImage;
	}

	public void setCreatorImage(String creatorImage) {
		this.creatorImage = creatorImage;
	}

	public String getProtagonist() {
		return protagonist;
	}

	public void setProtagonist(String protagonist) {
		this.protagonist = protagonist;
	}

	public String getProtagImage() {
		return protagImage;
	}

	public void setProtagImage(String protagImage) {
		this.protagImage = protagImage;
	}

	@Override
	public String toString() {
		return "Anime [id=" + id + ", name=" + name + ", releaseDate=" + releaseDate + ", showImage=" + showImage
				+ ", description=" + description + ", rating=" + rating + ", creator=" + creator + ", creatorImage="
				+ creatorImage + ", protagonist=" + protagonist + ", protagImage=" + protagImage + "]";
	}

}
