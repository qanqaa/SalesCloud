public with sharing class LogBuilder {
    public static Log__c record;

    public static void createLog(String messageType, HttpRequest request, HttpResponse response) {
        record = LogBuilder.getBuilder()
                .setMessageType(messageType)
                .setHttpMethod(request.getMethod())
                .setEndpoint(request.getEndpoint())
                .setStatusCode(response.getStatusCode())
                .setRequestBody(request.getBody())
                .setResponseBody(response.getBody())
                .save()
                .getRecord();
    }

    public static void createLog(String messageType, RestRequest request, Integer responseStatusCode, String responseBody) {
        record = LogBuilder.getBuilder()
                .setMessageType(messageType)
                .setHttpMethod(request.httpMethod)
                .setEndpoint(request.requestURI)
                .setStatusCode(responseStatusCode)
                .setRequestBody(request.requestBody.toString())
                .setResponseBody(responseBody)
                .save()
                .getRecord();
    }

    public static void createLog(String messageType, HttpRequest request, Integer responseStatusCode, String stackTrace) {
        record = LogBuilder.getBuilder()
                .setMessageType(messageType)
                .setHttpMethod(request.getMethod())
                .setEndpoint(request.getEndpoint())
                .setStatusCode(responseStatusCode)
                .setRequestBody(request.getBody())
                .setStackTrace(stackTrace)
                .save()
                .getRecord();
    }

    public static Builder getBuilder() {
        return new Builder();
    }

    public class Builder {
        public Log__c record;

        public Builder() {
            record = new Log__c();
        }

        public Builder setMessageType(String operationType) {
            record.Operation_Type__c = operationType;
            return this;
        }

        public Builder setEndpoint(String endpoint) {
            record.Endpoint__c = endpoint;
            return this;
        }

        public Builder setHttpMethod(String httpMethod) {
            record.Http_Method__c = httpMethod;
            return this;
        }

        public Builder setStatusCode(Decimal statusCode) {
            record.Status_Code__c = statusCode;
            return this;
        }

        public Builder setRequestBody(String requestBody) {
            record.Request_Body__c = requestBody;
            return this;
        }

        public Builder setResponseBody(String responseBody) {
            record.Response_Body__c = responseBody;
            return this;
        }

        public Builder setStackTrace(String stackTrace) {
            record.Stack_Trace__c = stackTrace;
            return this;
        }

        public Builder save() {
            insert record;
            return this;
        }

        public Log__c getRecord() {
            return record;
        }
    }
}