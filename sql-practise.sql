-- Create authors table
CREATE TABLE authors (
                         author_id SERIAL PRIMARY KEY,
                         first_name VARCHAR(50),
                         last_name VARCHAR(50),
                         email VARCHAR(100),
                         created_at TIMESTAMP DEFAULT NOW()
);

-- Create posts table
CREATE TABLE posts (
                       post_id SERIAL PRIMARY KEY,
                       title VARCHAR(100),
                       content TEXT,
                       created_at TIMESTAMP DEFAULT NOW()
);

-- Add about and nick columns into authors table
ALTER TABLE authors ADD COLUMN about TEXT;
ALTER TABLE authors ADD COLUMN nick VARCHAR(50);

-- Add UNIQUE CONSTRAINT for authors.nick and authors.email
ALTER TABLE authors ADD CONSTRAINT unique_nick UNIQUE (nick);
ALTER TABLE authors ADD CONSTRAINT unique_email UNIQUE (email);

-- Add image_url column into posts table
ALTER TABLE posts ADD COLUMN image_url VARCHAR(255);

-- Create subscribers table
CREATE TABLE subscribers (
                             subscriber_id SERIAL PRIMARY KEY,
                             email VARCHAR(100) NOT NULL
);

-- Add NOT_NULL CONSTRAINT for subscribers.email
ALTER TABLE subscribers ALTER COLUMN email SET NOT NULL;

-- Create authors_posts table for MANY TO MANY relation between authors and posts
CREATE TABLE authors_posts (
                               author_id INT,
                               post_id INT,
                               PRIMARY KEY (author_id, post_id),
                               FOREIGN KEY (author_id) REFERENCES authors(author_id),
                               FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

-- Create tags table
CREATE TABLE tags (
                      tag_id SERIAL PRIMARY KEY,
                      tag VARCHAR(50)
);

-- Create posts_tags table for MANY TO MANY relation between posts and tags
CREATE TABLE posts_tags (
                            post_id INT,
                            tag_id INT,
                            PRIMARY KEY (post_id, tag_id),
                            FOREIGN KEY (post_id) REFERENCES posts(post_id),
                            FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

-- Create INDEX for tags_tag column
CREATE INDEX idx_tag ON tags(tag);

-- Add github and updated_at columns into authors table
ALTER TABLE authors ADD COLUMN github VARCHAR(100);
ALTER TABLE authors ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();

-- Create a view for authors_posts_view
CREATE VIEW authors_posts_view AS
SELECT
    a.nick AS author_nick,
    p.title AS post_title,
    p.created_at AS post_created_at
FROM
    authors a
        JOIN
    authors_posts ap ON a.author_id = ap.author_id
        JOIN
    posts p ON ap.post_id = p.post_id;

-- Example ONE TO ONE relation
-- Create author_details table
CREATE TABLE author_details (
                                author_id INT PRIMARY KEY,
                                bio TEXT,
                                FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Example ONE TO MANY relation
-- Create comments table
CREATE TABLE comments (
                          comment_id SERIAL PRIMARY KEY,
                          post_id INT,
                          author_id INT,
                          content TEXT,
                          created_at TIMESTAMP DEFAULT NOW(),
                          FOREIGN KEY (post_id) REFERENCES posts(post_id),
                          FOREIGN KEY (author_id) REFERENCES authors(author_id)
);