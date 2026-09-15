import React, { useState, useEffect } from 'react';
import axios from 'axios';

function MovieList({ onMovieClick }) {
  const [movies, setMovies] = useState([]);

  useEffect(() => {
    const apiUrl = process.env.REACT_APP_MOVIE_API_URL || '/proxy/5000';
    axios.get(`${apiUrl}/movies`).then((response) => {
      setMovies(response.data.movies);
    });
  }, []);

  return (
    <div>
      {movies.map((movie) => (
        <div key={movie.id} onClick={() => onMovieClick(movie)}>
          <h3>{movie.title}</h3>
        </div>
      ))}
    </div>
  );
}

export default MovieList;