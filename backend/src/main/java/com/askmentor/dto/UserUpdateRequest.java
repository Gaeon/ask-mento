package com.askmentor.dto;

public class UserUpdateRequest {
    private String name;
    private String password;
    private int department_id;
    private String join_year;
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getDepartment_id() {
        return department_id;
    }

    public void setDepartment_id(int department_id) {
        this.department_id = department_id;
    }

    public String getJoin_year() {
        return join_year;
    }

    public void setJoin_year(String join_year) {
        this.join_year = join_year;
    }
}