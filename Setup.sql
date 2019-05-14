/*  File Location:
        C:\Users\Derek\OneDrive\Desktop\IS480_Project\Setup.sql   */

set echo on
set serveroutput on

/* ---------------
   Create table structure for IS 480 class
   --------------- */

drop table enrollments;
drop table prereq;
drop table waitlist;
drop table schclasses;
drop table courses;
drop table students;
drop table majors;


-----
-----


create table MAJORS
	(major varchar2(3) Primary key,
	mdesc varchar2(30));
insert into majors values ('ACC','Accounting');
insert into majors values ('FIN','Finance');
insert into majors values ('IS','Information Systems');
insert into majors values ('MKT','Marketing');

create table STUDENTS 
	(snum varchar2(3) primary key,
	sname varchar2(10),
	standing number(1),
	major varchar2(3) constraint fk_students_major references majors(major),
	gpa number(2,1),
	major_gpa number(2,1));

insert into students values ('101','Andy',3,'IS',2.8,3.2);
insert into students values ('102','Betty',2,null,3.2,null);
insert into students values ('103','Cindy',3,'IS',2.5,3.5);
insert into students values ('104','David',2,'FIN',3.3,3.0);
insert into students values ('105','Ellen',1,null,2.8,null);
insert into students values ('106','Frank',3,'MKT',3.1,2.9);

create table COURSES
	(dept varchar2(3) constraint fk_courses_dept references majors(major),
	cnum varchar2(3),
	ctitle varchar2(30),
	crhr number(3),
	standing number(1),
	primary key (dept,cnum));

insert into courses values ('IS','300','Intro to MIS',3,2);
insert into courses values ('IS','301','Business Communicatons',3,2);
insert into courses values ('IS','310','Statistics',3,2);
insert into courses values ('IS','340','Programming',3,3);
insert into courses values ('IS','380','Database',3,3);
insert into courses values ('IS','385','Systems',3,3);
insert into courses values ('IS','480','Adv Database',3,4);

create table SCHCLASSES (
	callnum number(5) primary key,
	year number(4),
	semester varchar2(3),
	dept varchar2(3),
	cnum varchar2(3),
	section number(2),
	capacity number(3));

alter table schclasses 
	add constraint fk_schclasses_dept_cnum foreign key 
	(dept, cnum) references courses (dept,cnum);

insert into schclasses values (10110,2014,'Fa','IS','300',1,45);
insert into schclasses values (10115,2014,'Fa','IS','300',2,118);
insert into schclasses values (10120,2014,'Fa','IS','300',3,35);
insert into schclasses values (10125,2014,'Fa','IS','301',1,35);
insert into schclasses values (10130,2014,'Fa','IS','301',2,35);
insert into schclasses values (10135,2014,'Fa','IS','310',1,35);
insert into schclasses values (10140,2014,'Fa','IS','310',2,35);
insert into schclasses values (10145,2014,'Fa','IS','340',1,30);
insert into schclasses values (10150,2014,'Fa','IS','380',1,33);
insert into schclasses values (10155,2014,'Fa','IS','385',1,35);
insert into schclasses values (10160,2014,'Fa','IS','480',1,35);

create table PREREQ
	(dept varchar2(3),
	cnum varchar2(3),
	pdept varchar2(3),
	pcnum varchar2(3),
	primary key (dept, cnum, pdept, pcnum));
alter table Prereq 
	add constraint fk_prereq_dept_cnum foreign key 
	(dept, cnum) references courses (dept,cnum);
alter table Prereq 
	add constraint fk_prereq_pdept_pcnum foreign key 
	(pdept, pcnum) references courses (dept,cnum);

insert into prereq values ('IS','380','IS','300');
insert into prereq values ('IS','380','IS','301');
insert into prereq values ('IS','380','IS','310');
insert into prereq values ('IS','385','IS','310');
insert into prereq values ('IS','340','IS','300');
insert into prereq values ('IS','480','IS','380');

create table ENROLLMENTS (
	snum varchar2(3) constraint fk_enrollments_snum references students(snum),
	callnum number(5) constraint fk_enrollments_callnum references schclasses(callnum),
	grade varchar2(2),
	primary key (snum, callnum));

insert into enrollments values (101,10110,'A');
insert into enrollments values (102,10110,'B');
insert into enrollments values (103,10120,'A');
insert into enrollments values (101,10125,null);
insert into enrollments values (102,10130,null);

/*  For Testing:    */
insert into enrollments values(103, 10135, null);
insert into enrollments values(104, 10160, null);
insert into enrollments values(105, 10125, null);
insert into enrollments values(101, 10135, null);
insert into enrollments values(101, 10145, null);
insert into enrollments values(101, 10160, null);


insert into students (snum, sname, standing, major) values ('107','Fredrick', '4', null);
insert into students (snum, sname, standing, major) values ('108','Tyrion', '3', 'IS');
insert into students (snum, sname, standing, major) values ('109','Jaime', '2', 'IS');
insert into students (snum, sname, standing, major) values ('110','Stark', '2', 'IS');
insert into students (snum, sname, standing, major) values ('111','Cerce', '4', 'IS');
insert into students values ('112','Greg',3,'FIN',2.4,2.9);
insert into students values ('113','Ron',3,'FIN',3.2,2.9);
insert into students values ('114','Kris',3,'FIN',2.8,2.9);
insert into students values ('115','Greg',3,'FIN',2.4,2.9);

update students set gpa = '1.8' where snum = '109';
update students set gpa = '3.9' where snum = '111';
update students set major = 'MKT' where snum = '102';
update students set major = 'MKT' where snum = '105'; 

--Waitlist table
create table WaitList(
	snum varchar2(3) constraint fk_waitlist_snum references students(snum),
	callnum number(5) constraint fk_waitlist_callnum references schclasses(callnum),
	wdate timestamp,
	primary key (snum, callnum));
/*
insert into waitlist values ('111','10110', sysdate);
insert into waitlist values ('101','10160', sysdate);
insert into waitlist values ('102','10135', sysdate);
insert into waitlist values ('110','10110', sysdate);
*/

--MIGHT NEED TO CHANGE -\/- *******************************************!!!!!!!!!!!!!!*******&&&&&&&&
update schclasses set capacity = '3' /*'3 or 4'*/ where callnum = '10110'; 

alter table students add (credits number(2));
/* update credits column */

update students 
    set credits = (select cr
        from (select students.snum, 
            sum(CrHr) as cr
            from courses, schclasses, enrollments, students
            where courses.dept = schclasses.dept
            and courses.cnum = schclasses.cnum
            and schclasses.callnum = enrollments.callnum
            and students.snum = enrollments.snum
            group by students.snum
            ) temp
        where students.snum = temp.snum);

commit;


create or replace package ENROLL AS

-- AddMe MAIN PROGRAM =============================
Procedure AddMe(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type,
    p_ErrorMsg OUT varchar2);
-- DropMe MAIN PROGRAM ==========================
Procedure DropMe(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type);
End ENROLL;
/

create or replace package Body ENROLL AS
-- AddMe COMPONENTS -------------------------------
-- #1.a
Procedure proc_validate_student(
    p_snum students.snum%type,
    p_error OUT varchar2) as
    v_count number(3);
begin
    select count(snum) into v_count
        from students
        where snum=p_snum;
    if v_count = 1 then
        p_error := null;
    else
        p_error := 'Student '||p_snum||' does not exist. ';
    end if;
end;
-- #1.b
Procedure proc_validate_callnum(
    p_callnum schclasses.callnum%type,
    p_error out varchar2) as
    v_count number(3);

begin
    select count(callnum) into v_count
        from schclasses
        where callnum = p_callnum;
    if v_count = 1 then
        p_error := null;
    else
        p_error := 'Class '||p_callnum||' does not exist. ';
    end if;
end;
-- #2
Function func_check_repeat( --FOR CALLNUM
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type)
    return varchar2 AS
    v_count number(2);

BEGIN
    select count(callnum) into v_count
        from enrollments
        where callnum = p_callnum
        and snum = p_snum;
    IF v_count = 1 THEN
        return 'Student '||p_snum||' has already enrolled in class number ' || p_callnum||'. ';
    ELSE
        return null;
    end if;
END;
-- #3
Function func_check_double( --FOR DEPT AND CNUM
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type)
    return varchar2 as 
    v_dept varchar2(1000);
    v_cnum varchar2(1000);
    v_course varchar2(1000);
    v_count number(2);
BEGIN
    select dept into v_dept 
        from schclasses
        where schclasses.callnum = p_callnum;
    select cnum into v_cnum 
        from schclasses
        where schclasses.callnum = p_callnum;
    v_course := v_dept || ' ' || v_cnum;
    select count(enrollments.callnum) into v_count
    from enrollments, schclasses
    where enrollments.callnum = schclasses.callnum
    and dept = v_dept
    and cnum = v_cnum
    and snum = p_snum;
    if v_count != 0 then 
        return 'Student '||p_snum||' has already enrolled in ' || v_course || '. ';
    else
        return null;
    end if;
end;
-- #4
Procedure proc_validate_credits(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type,
    p_error OUT varchar2) as
    v_current_credits students.credits%type;
    v_class_credits courses.crhr%type;
    
begin
    select nvl(credits, 0) into v_current_credits
        from students
        where snum = p_snum;

    select crhr into v_class_credits
        from courses, schclasses
        where courses.dept = schclasses.dept
        and courses.cnum = schclasses.cnum
        and callnum=p_callnum;
    if v_current_credits + v_class_credits > 15 then
        p_error := 'Adding class '||p_callnum||' will exceed maximum of 15 credits for student '||p_snum||'. ';
    else
        p_error := null;
    end if;
end;
-- #5
Function func_check_standing(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type)
    return varchar2 as
    v_stu_standing number(1);
    v_cl_standing number(1);
BEGIN
    select standing into v_stu_standing
        from students
        where snum = p_snum;
    select courses.standing into v_cl_standing
        from courses, schclasses
        where schclasses.dept = courses.dept
        and schclasses.cnum = courses.cnum
        and callnum = p_callnum;
    IF v_stu_standing >= v_cl_standing then 
        return null;
    ELSE
        return 'Student '||p_snum||' must have standing of '||v_cl_standing||' or higher to enroll in class '||p_callnum||'. ';
    END IF;
end;
-- #6
Function func_check_major(
    p_snum students.snum%type)
    return varchar2 as
    v_stu_standing number(1);
    v_major varchar2(5);
BEGIN
    select standing into v_stu_standing
        from students
        where snum = p_snum;
    select major into v_major
        from students
        where snum = p_snum;
    IF nvl(v_stu_standing, 0) >= 3 then
        if v_major is null then
            return 'Students with standing of 3 or higher must declare major to enroll. ';
        else
            return null;
        end if;
    ELSE
        return null;
    END IF;
END;
-- #7
Function func_validate_space(
    p_callnum schclasses.callnum%type)
    return varchar2 as
    v_currentlyEnrolled number(3);
    v_capacity schclasses.capacity%type;
    v_W number (3);
begin
    select count(callnum) into v_currentlyEnrolled
        from enrollments
        where callnum = p_callnum;
    select count (callnum) into v_W
        from enrollments
        where grade = 'W'
        and callnum = p_callnum;
    v_currentlyEnrolled := v_currentlyEnrolled - v_W;
    select capacity into v_capacity
        from schclasses
        where callnum = p_callnum;
    if (v_currentlyEnrolled + 1) <= v_capacity then
        return null;
    else
        return 'Class '|| p_callnum ||' capacity of '||v_capacity||' has already been filled. ';
    end if;
end;
-- #8
Function func_add2wait(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type)
    return varchar2 as
BEGIN
    insert into waitlist values (p_snum, p_callnum, sysdate);
    return 'Student '||p_snum||' has been added to waiting list for class '||p_callnum||'. ';
END;
-- #9
Function func_check_wait(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type)
    return varchar2 as 
    v_count number(1);
BEGIN
    select count(snum) into v_count
        from waitlist
        where snum = p_snum
        and callnum = p_callnum;
    IF v_count > 0 then
        return 'Student number '||p_snum||' is already on the wait list for class number '||p_callnum||'. ';
    ELSE
        return null;
    END IF;
END;
Procedure proc_get_credits(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type,
    p_current_credits out number,
    p_class_credits out number) as
BEGIN
    select nvl(credits, 0) into p_current_credits
        from students
        where snum = p_snum;
    select crhr into p_class_credits
        from courses, schclasses
        where courses.dept = schclasses.dept
        and courses.cnum = schclasses.cnum
        and callnum = p_callnum;
END;

-- AddMe MAIN PROGRAM =============================
Procedure AddMe(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type,
    p_ErrorMsg OUT varchar2) as
    v_temp varchar2(1000);
    v_full varchar2(1000);
    v_current_credits number(3);
    v_class_credits number(3);
BEGIN
    proc_validate_student(p_snum, v_temp);
    v_full := v_temp;
    proc_validate_callnum(p_callnum, v_temp);
    v_full := v_full || v_temp;
    IF v_full is null then
        v_temp := func_check_repeat(p_snum, p_callnum);
        --v_full := v_full || func_check_repeat(p_snum, p_callnum); --CALLNUM
        v_full := v_full || v_temp;
        If v_temp is null then
            v_full := v_full || func_check_double(p_snum, p_callnum);--dept + cnum
        End If;
        proc_validate_credits(p_snum, p_callnum, v_temp);
        v_full := v_full || v_temp;
        v_full := v_full || func_check_standing(p_snum, p_callnum);
        v_full := v_full || func_check_major(p_snum);
        v_temp := func_validate_space(p_callnum);
        If v_temp is not null and v_full is null then
            v_full := v_full||v_temp;
            v_temp := func_check_wait(p_snum, p_callnum);
            if v_temp is null then 
                v_temp := func_add2wait(p_snum, p_callnum);
                v_full := v_full||v_temp;
                p_ErrorMsg := v_full;
                dbms_output.put_line('Error(s): '||v_full);
            else 
                v_temp := func_check_wait(p_snum, p_callnum);
                v_full := v_full||v_temp;
                p_ErrorMsg := v_full;
                dbms_output.put_line('Error(s): '||v_full); 
            end if;
        Else
            if v_full is null then 
                insert into enrollments values (p_snum, p_callnum, null);
                p_ErrorMsg := v_full;
                proc_get_credits(p_snum, p_callnum, v_current_credits, v_class_credits);
                update students set credits = (v_current_credits + v_class_credits)
                    where snum = p_snum;
                dbms_output.put_line('Congratulations! Student '||p_snum||' has enrolled in class '||p_callnum||'!');
                --DO I SAVE THIS POSITIVE CONFIRMATION TO p_ErrorMsg?

            else
                p_ErrorMsg := v_full;
                dbms_output.put_line('Error(s): '||p_ErrorMsg);
            end if;
        End If;
    ELSE
        p_ErrorMsg := v_full;
        dbms_output.put_line('Error(s): '||p_ErrorMsg);
    END IF;
    commit;
END;

-- DropMe COMPONENTS ------------------------------
-- #2
Function func_check_enrolled(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type)
    return varchar2 as
    v_count number(2);
BEGIN
    select count(callnum) into v_count
        from enrollments
        where snum = p_snum
        and callnum = p_callnum;
    IF v_count = 0 then
        return 'Cannot drop because Student '||p_snum||' is not enrolled in class '||p_callnum||'. ';
    ELSE
        return null;
    END IF;
END;
-- #3
Function func_check_graded(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type)
    return varchar2 as
    v_grade varchar2(2);
BEGIN
    select grade into v_grade
        from enrollments
        where snum = p_snum
        and callnum = p_callnum;
    IF v_grade is null then
        return null;
    ELSE
        If v_grade = 'W' then
            return 'Student '||p_snum||' has already dropped class '||p_callnum;
        Else
            return 'Student '||p_snum||' has already received grade in class number '||p_callnum;
        End If;
    END IF;
END;
-- #4
Procedure proc_W(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type,
    p_check OUT varchar2) as
BEGIN
    update enrollments
        set grade = 'W'
        where snum = p_snum
        and callnum = p_callnum;
    p_check := 'true';
END;
-- #5
Procedure proc_add_new_student(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type) as
    v_error varchar2 (1000);
    v_count number (3);
    cursor cSortedWait is
        select snum, callnum, wdate 
            from WaitList
            where callnum = p_callnum
            order by wdate asc; --HERE
BEGIN
    select count(snum) into v_count
        from waitlist
        where callnum = p_callnum;
    IF v_count > 0 then 
        for rec in cSortedWait LOOP
            dbms_output.put_line('Attempting student '||rec.snum||'...');
            Enroll.AddMe(rec.snum, rec.callnum, v_error);
            if v_error is null then 
                delete from waitlist
                    where snum = rec.snum and callnum = rec.callnum;
            end if;    
        exit when v_error is null;
        END LOOP;
    ELSE 
        dbms_output.put_line('No students on wait list for class '||p_callnum);
    END IF;
End;



-- DropMe MAIN PROGRAM ==========================
Procedure DropMe(
    p_snum students.snum%type,
    p_callnum schclasses.callnum%type) as
    v_temp varchar2(1000);
    v_full varchar2(1000);
    v_current_credits number(3);
    v_class_credits number(3);
    v_capacity_full varchar2(1000);
BEGIN
    proc_validate_student(p_snum, v_temp);
    v_full := v_temp;
    proc_validate_callnum(p_callnum, v_temp);
    v_full := v_full || v_temp;
    IF v_full is null then
        v_full := v_full||func_check_enrolled(p_snum, p_callnum);
        If v_full is null then 
            v_full := v_full||func_check_graded(p_snum, p_callnum);
            if v_full is null then 
                v_capacity_full := func_validate_space(p_callnum);
                proc_W(p_snum, p_callnum, v_temp);
                proc_get_credits(p_snum, p_callnum, v_current_credits, v_class_credits);
                update students set credits = (v_current_credits - v_class_credits)
                    where snum = p_snum;
                dbms_output.put_line('Congratulations! Student '||p_snum||' has dropped class '||p_callnum||'. ');
                IF v_temp = 'true' then
                    If v_capacity_full is not null then 
                        dbms_output.put_line('Attempting to add new student from wait list...');
                        proc_add_new_student(p_snum,p_callnum);
                    End If;
                END IF;
            else
                dbms_output.put_line('Error(s): '||v_full);
            end if;
        Else
            dbms_output.put_line('Error(s): '||v_full);
        End If;
    ELSE
        dbms_output.put_line('Error(s): '||v_full);
    END IF;
    commit;
END;

End ENROLL;
/
