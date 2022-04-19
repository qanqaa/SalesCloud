public with sharing class CommentController {

    @AuraEnabled
    public static void saveComment(String commentText, Integer rate, String objectId) {
        Spotify_Property__c newComment = new Spotify_Property__c();
        newComment.Comment__c = commentText;
        newComment.Rating__c = rate;
        newComment.ObjectId__c = objectId;

        Database.SaveResult saveResult = Database.insert(newComment);
        System.debug(string.valueOf(saveResult));
//        return string.valueOf(saveResult);
    }
}