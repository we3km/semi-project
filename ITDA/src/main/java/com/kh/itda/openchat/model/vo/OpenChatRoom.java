package com.kh.itda.openchat.model.vo;

public class OpenChatRoom {
    private int roomId;
    private String title;
    private String tags;
    private int currentMembers;
    private int maxMembers;

    // Getter/Setter
    public int getRoomId() {
        return roomId;
    }
    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getTags() {
        return tags;
    }
    public void setTags(String tags) {
        this.tags = tags;
    }
    public int getCurrentMembers() {
        return currentMembers;
    }
    public void setCurrentMembers(int currentMembers) {
        this.currentMembers = currentMembers;
    }
    public int getMaxMembers() {
        return maxMembers;
    }
    public void setMaxMembers(int maxMembers) {
        this.maxMembers = maxMembers;
    }
}
