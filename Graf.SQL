/*
Created: 05.05.2026
Modified: 05.05.2026
Model: Microsoft SQL Server 2019
Database: MS SQL Server 2019
*/
Use master
go

drop database if exists Kindergarten
go

create database Kindergarten
go

Use Kindergarten
go

-- Create tables section -------------------------------------------------

-- Table NodeChild

CREATE TABLE [NodeChild]
(
 [ChildID] Int NOT NULL,
 [Name] Nvarchar(100) NOT NULL,
 [Age] Int NOT NULL,
 [GroupName] Nvarchar(50) NOT NULL,
 CONSTRAINT [PK_NodeChild] PRIMARY KEY ([ChildID])
)
AS NODE
go

-- Table NodeTeacher

CREATE TABLE [NodeTeacher]
(
 [TeacherID] Int NOT NULL,
 [Name] Nvarchar(100) NOT NULL,
 [Specialty] Nvarchar(100) NOT NULL,
 [HireDate] Date NOT NULL,
 CONSTRAINT [PK_NodeTeacher] PRIMARY KEY ([TeacherID])
)
AS NODE
go

-- Table NodeHobbyGroup

CREATE TABLE [NodeHobbyGroup]
(
 [HobbyID] Int NOT NULL,
 [Title] Nvarchar(100) NOT NULL,
 [DayOfWeek] Nvarchar(20) NOT NULL CHECK ([DayOfWeek] IN(N'Понедельник', N'Вторник', N'Среда', N'Четверг', N'Пятница', N'Суббота', N'Воскресенье')),
 [MaxChildren] Int NOT NULL,
 CONSTRAINT [PK_NodeHobbyGroup] PRIMARY KEY ([HobbyID])
)
AS NODE
go

-- Table EdgeAttendsHobby

CREATE TABLE [EdgeAttendsHobby]
(
 [AttendanceDate] Date NOT NULL,
 [Rating] Tinyint NULL CHECK (Rating BETWEEN 1 AND 5)
)
AS EDGE
go

-- Add connection constraints for table EdgeAttendsHobby

ALTER TABLE [EdgeAttendsHobby] ADD CONSTRAINT [EC_NodeChild_NodeHobbyGroup] CONNECTION (
  [NodeChild] TO [NodeHobbyGroup])
go

-- Table EdgeTeachesChild

CREATE TABLE [EdgeTeachesChild]
(
 [AssignedSince] Date NOT NULL,
 [IsMainTeacher] Bit DEFAULT 1 NOT NULL,
 [Notes] Nvarchar(255) NULL
)
AS EDGE
go

-- Add connection constraints for table EdgeTeachesChild

ALTER TABLE [EdgeTeachesChild] ADD CONSTRAINT [EC_NodeTeacher_NodeChild] CONNECTION (
  [NodeTeacher] TO [NodeChild])
go

-- Table EdgeFriendship

CREATE TABLE [EdgeFriendship]
(
 [FriendshipStrength] Int NOT NULL CHECK (FriendshipStrength BETWEEN 1 AND 10),
 [SinceDate] Date NOT NULL
)
AS EDGE
go

-- Add connection constraints for table EdgeFriendship

ALTER TABLE [EdgeFriendship] ADD CONSTRAINT [EC_NodeChild_NodeChild] CONNECTION (
  [NodeChild] TO [NodeChild])
go

--Заполняем таблицу NodeChild

INSERT INTO NodeChild VALUES 
    (1, 'Алиса Иванова', 5, 'Старшая'),
    (2, 'Богдан Петров', 4, 'Средняя'),
    (3, 'Вика Сидорова', 5, 'Старшая'),
    (4, 'Глеб Морозов', 3, 'Младшая'),
    (5, 'Дарья Козлова', 4, 'Средняя'),
    (6, 'Егор Васильев', 5, 'Старшая'),
    (7, 'Жанна Лебедева', 3, 'Младшая'),
    (8, 'Захар Новиков', 4, 'Средняя'),
    (9, 'Ирина Соколова', 5, 'Старшая'),
    (10, 'Кирилл Попов', 3, 'Младшая'),
    (11, 'Лариса Тихонова', 4, 'Средняя'),
    (12, 'Михаил Фёдоров', 5, 'Старшая');

 --Заполняем таблицу NodeTeacher

INSERT INTO NodeTeacher VALUES 
    (101, 'Мария Ивановна Смирнова', 'логопед', '2010-09-01'),
    (102, 'Ольга Петровна Кузнецова', 'музыкальный руководитель', '2012-01-15'),
    (103, 'Анна Владимировна Волкова', 'воспитатель старшей группы', '2015-08-20'),
    (104, 'Елена Сергеевна Морозова', 'воспитатель средней группы', '2016-09-01'),
    (105, 'Татьяна Юрьевна Новикова', 'воспитатель младшей группы', '2018-03-10'),
    (106, 'Игорь Александрович Соколов', 'инструктор по физкультуре', '2014-11-01'),
    (107, 'Наталья Павловна Лебедева', 'педагог-психолог', '2017-09-15'),
    (108, 'Светлана Дмитриевна Зайцева', 'логопед', '2019-01-20'),
    (109, 'Константин Борисович Орлов', 'хореограф', '2013-07-01'),
    (110, 'Людмила Егоровна Тимофеева', 'воспитатель ясельной группы', '2020-09-01'),
    (111, 'Вера Михайловна Крылова', 'воспитатель подготовительной группы', '2011-08-25');

--Заполняем таблицу NodeHobbyGroup

INSERT INTO NodeHobbyGroup VALUES 
    (201, 'Юный художник', 'Понедельник', 12),
    (202, 'LEGO-конструирование', 'Среда', 10),
    (203, 'Веселые танцы', 'Вторник', 15),
    (204, 'Театр кукол', 'Пятница', 10),
    (205, 'Шахматы', 'Четверг', 8),
    (206, 'Английский язык', 'Вторник', 12),
    (207, 'Футбол', 'Среда', 15),
    (208, 'Карате', 'Пятница', 10),
    (209, 'Робототехника', 'Понедельник', 8),
    (210, 'Оригами', 'Четверг', 12),
    (211, 'Вокал', 'Среда', 10);

--Создаём двусторонние дружеские связи

INSERT INTO EdgeFriendship VALUES 
    --Старшая группа
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 1),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 3), 10, '2024-09-15'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 3),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), 10, '2024-09-15'),
    
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 1),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 6), 8, '2024-10-01'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 6),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), 8, '2024-10-01'),
    
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 1),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 9), 9, '2024-09-20'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 9),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), 9, '2024-09-20'),
   
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 3),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 6), 7, '2024-11-01'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 6),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 3), 7, '2024-11-01'),
    
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 3),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 12), 6, '2024-12-10'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 12),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 3), 6, '2024-12-10'),

    ((SELECT $node_id FROM NodeChild WHERE ChildID = 6),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 12), 10, '2024-10-15'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 12),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 6), 10, '2024-10-15'),
    
    -- Средняя группа
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 2),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 5), 7, '2024-11-20'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 5),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 2), 7, '2024-11-20'),
    
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 2),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 8), 8, '2024-10-05'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 8),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 2), 8, '2024-10-05'),
    
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 5),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 11), 9, '2024-12-01'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 11),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 5), 9, '2024-12-01'),

     -- Младшая группа
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 4),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 7), 5, '2025-01-10'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 7),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 4), 5, '2025-01-10'),
    
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 4),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 10), 6, '2024-12-15'),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 10),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 4), 6, '2024-12-15');

--Рёбра "Воспитывает" 

     INSERT INTO EdgeTeachesChild VALUES 
    -- Мария Ивановна (101) - логопед, работает с детьми старшей группы
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 101),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), '2024-09-01', 0, 'логопедия'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 101),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 3), '2024-09-01', 0, 'логопедия'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 101),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 6), '2024-09-01', 0, 'логопедия'),
    
    -- Ольга Петровна (102) - музыкальный руководитель
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 102),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), '2024-09-01', 0, 'музыка'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 102),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 2), '2024-09-01', 0, 'музыка'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 102),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 5), '2024-09-01', 0, 'музыка'),
    
    -- Анна Владимировна (103) - воспитатель старшей группы
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 103),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), '2023-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 103),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 3), '2023-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 103),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 6), '2023-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 103),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 9), '2023-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 103),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 12), '2024-09-01', 1, 'новенький'),

     -- Елена Сергеевна (104) - воспитатель средней группы
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 104),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 2), '2024-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 104),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 5), '2024-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 104),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 8), '2024-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 104),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 11), '2024-09-01', 1, NULL),
    
    -- Татьяна Юрьевна (105) - воспитатель младшей группы
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 105),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 4), '2024-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 105),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 7), '2024-09-01', 1, NULL),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 105),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 10), '2024-09-01', 1, NULL),
    
    -- Игорь Александрович (106) - физрук
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 106),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), '2024-09-01', 0, 'ОФП'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 106),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 2), '2024-09-01', 0, 'ОФП'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 106),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 4), '2024-09-01', 0, 'ОФП'),

     -- Константин Борисович (109) - хореограф
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 109),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 1), '2024-09-01', 0, 'ритмика'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 109),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 3), '2024-09-01', 0, 'ритмика'),
    ((SELECT $node_id FROM NodeTeacher WHERE TeacherID = 109),
     (SELECT $node_id FROM NodeChild WHERE ChildID = 5), '2024-09-01', 0, 'ритмика');

--Посещают кружки

     INSERT INTO EdgeAttendsHobby VALUES 
    -- Алиса (1) 
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 1),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 201), '2024-09-10', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 1),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 203), '2024-09-12', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 1),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 206), '2024-09-15', 4),
    
    -- Богдан (2) 
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 2),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 202), '2024-09-10', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 2),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 207), '2024-09-14', 4),
    
    -- Вика (3) 
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 3),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 201), '2024-09-10', 4),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 3),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 204), '2024-09-15', 5),
    
    -- Глеб (4)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 4),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 210), '2024-10-01', 5),
    
    -- Дарья (5)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 5),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 203), '2024-09-12', 4),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 5),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 206), '2024-09-15', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 5),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 211), '2024-10-05', 4),
    
    -- Егор (6)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 6),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 202), '2024-09-10', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 6),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 207), '2024-09-14', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 6),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 209), '2024-10-01', 5),
    
    -- Жанна (7)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 7),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 210), '2024-10-01', 4),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 7),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 211), '2024-10-05', 5),
    
    -- Захар (8)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 8),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 205), '2024-09-20', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 8),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 209), '2024-10-01', 4),
    
    -- Ирина (9)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 9),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 201), '2024-09-10', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 9),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 204), '2024-09-15', 5),
    
    -- Кирилл (10)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 10),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 207), '2024-09-14', 4),
    
    -- Лариса (11)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 11),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 203), '2024-09-12', 5),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 11),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 206), '2024-09-15', 4),
    
    -- Михаил (12)
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 12),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 205), '2024-09-20', 4),
    ((SELECT $node_id FROM NodeChild WHERE ChildID = 12),
     (SELECT $node_id FROM NodeHobbyGroup WHERE HobbyID = 209), '2024-10-01', 5);

-- Найти детей, которые ходят в те же кружки, что и Алиса

SELECT DISTINCT 
    a.Name AS MainChild,
    a.[ChildID] AS ImageOfAlice,
    hg.Title AS HobbyGroup,
    c2.Name AS SameGroupChild,
    c2.[ChildID] AS ImageOfChild
FROM NodeChild a, EdgeAttendsHobby ea1, NodeHobbyGroup hg,
     EdgeAttendsHobby ea2, NodeChild c2
WHERE MATCH(a-(ea1)->hg<-(ea2)-c2)
    AND a.ChildID = 1  
    AND c2.ChildID != 1
ORDER BY hg.Title, c2.Name;

-- Найти детей, у которых есть общий воспитатель с Алисой

SELECT DISTINCT 
    a.Name AS Alice,
    t.Name AS CommonTeacher,
    c2.Name AS OtherChild
FROM NodeChild a, EdgeTeachesChild et1, NodeTeacher t,
     EdgeTeachesChild et2, NodeChild c2
WHERE MATCH(a<-(et1)-t-(et2)->c2)
    AND a.ChildID = 1 
    AND c2.ChildID != 1
    AND et1.IsMainTeacher = 1  
    AND et2.IsMainTeacher = 1
ORDER BY t.Name, c2.Name;

-- Найти кружки, которые посещают друзья друзей Алисы

SELECT DISTINCT
    a.Name AS StartChild,
    friend1.Name AS DirectFriend,
    friend2.Name AS FriendOfFriend,
    friend2.ChildID AS ImageOfChild,
    hg.Title AS HobbyGroup,
    hg.HobbyID AS ImageOfHobby
FROM NodeChild a, EdgeFriendship ef1, NodeChild friend1,
     EdgeFriendship ef2, NodeChild friend2,
     EdgeAttendsHobby ea, NodeHobbyGroup hg
WHERE MATCH(a-(ef1)->friend1-(ef2)->friend2-(ea)->hg)
    AND a.ChildID = 1 
    AND friend1.ChildID != a.ChildID
    AND friend2.ChildID != a.ChildID
    AND friend2.ChildID != friend1.ChildID
ORDER BY hg.Title;

-- Найти всех воспитателей, которые работают с детьми, посещающими кружок 'Юный художник'

SELECT DISTINCT
    hg.Title AS HobbyGroup,
    c.Name AS Child,
    c.ChildID AS ImageOfChild,
    t.Name AS Teacher,
    t.[TeacherID] AS ImageOfTeacher,
    t.Specialty
FROM NodeHobbyGroup hg, EdgeAttendsHobby ea, NodeChild c,
     EdgeTeachesChild etc, NodeTeacher t
WHERE MATCH(hg<-(ea)-c<-(etc)-t)
    AND hg.HobbyID = 201
ORDER BY c.Name, t.Name;

-- Друзья детей, у которых есть общий кружок с Алисой

SELECT DISTINCT
    a.Name AS Alice,
    sameHobby.Name AS SameHobbyChild,
    friend2.Name AS FriendOfSameHobbyChild
FROM NodeChild a, EdgeAttendsHobby ea1, NodeHobbyGroup hg,
     EdgeAttendsHobby ea2, NodeChild sameHobby,
     EdgeFriendship ef, NodeChild friend2
WHERE MATCH(a-(ea1)->hg<-(ea2)-sameHobby-(ef)->friend2)
    AND a.ChildID = 1
    AND sameHobby.ChildID != a.ChildID
    AND friend2.ChildID != a.ChildID
    AND friend2.ChildID != sameHobby.ChildID
ORDER BY sameHobby.Name, friend2.Name;

-- Найти кратчайший путь дружбы от Алисы до Михаила

SELECT * 
FROM (
    SELECT 
        Alice.Name AS FromNode,
        STRING_AGG(Friend.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FullPath
    FROM 
        NodeChild AS Alice,
        EdgeFriendship FOR PATH AS ef,
        NodeChild FOR PATH AS Friend
    WHERE MATCH(SHORTEST_PATH(Alice(-(ef)->Friend)+))
    AND Alice.ChildID = 1
) AS Result
WHERE FullPath LIKE '%Михаил Фёдоров';

-- Найти кратчайший путь дружбы от Егора до Вики

SELECT * 
FROM (
    SELECT 
        StartNode.Name AS FromNode,
        STRING_AGG(TargetNode.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FullPath,
        COUNT(TargetNode.Name) WITHIN GROUP (GRAPH PATH) AS Distance
    FROM 
        NodeChild AS StartNode,
        EdgeFriendship FOR PATH AS ef,
        NodeChild FOR PATH AS TargetNode
    WHERE MATCH(SHORTEST_PATH(StartNode(-(ef)->TargetNode){1,3}))
    AND StartNode.ChildID = 6
) AS Result
WHERE FullPath LIKE '%Вика Сидорова';

select @@servername