-- Create iris table
CREATE TABLE IF NOT EXISTS iris (
    id SERIAL PRIMARY KEY,
    sepal_length FLOAT NOT NULL,
    sepal_width FLOAT NOT NULL,
    petal_length FLOAT NOT NULL,
    petal_width FLOAT NOT NULL,
    species VARCHAR(50) NOT NULL
);

-- Insert sample iris data
INSERT INTO iris (sepal_length, sepal_width, petal_length, petal_width, species) VALUES
(5.1, 3.5, 1.4, 0.2, 'setosa'),
(4.9, 3.0, 1.4, 0.2, 'setosa'),
(4.7, 3.2, 1.3, 0.2, 'setosa'),
(7.0, 3.2, 4.7, 1.4, 'versicolor'),
(6.4, 3.2, 4.5, 1.5, 'versicolor'),
(6.9, 3.1, 4.9, 1.5, 'versicolor'),
(6.3, 3.3, 6.0, 2.5, 'virginica'),
(5.8, 2.7, 5.1, 1.9, 'virginica'),
(7.1, 3.0, 5.9, 2.1, 'virginica');