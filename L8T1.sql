USE movies

alter table movie 
add constraint unique_length unique(length); 

alter table movie 
add constraint unique_studio_length unique(studioname,length); 



ALTER TABLE MOVIE
DROP CONSTRAINT unique_length

ALTER TABLE MOVIE
DROP CONSTRAINT unique_studio_length