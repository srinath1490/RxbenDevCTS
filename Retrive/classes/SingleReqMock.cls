@isTest
global class SingleReqMock implements HttpCalloutMock {
    
    protected integer code;
    protected string status;
    protected string bodyAsString;
    protected blob    bodyAsBlob;
    protected Map<String, String> responseHeaders;

    public SingleReqMock(Integer Code, String Status, String Body, Map<String, String> responseHeaders){
        this.code = code;
        this.status = status;
        this.bodyAsString = body;
        this.bodyAsBlob = null;
        this.responseHeaders = responseHeaders;
        }

    public HTTPResponse respond(HTTPRequest req){
        HTTPResponse resp = new HTTPResponse();
        resp.setStatusCode(code);
        resp.setstatus(status);
        If (bodyAsBlob != null) {
            resp.setBodyAsBlob(bodyAsBlob);
            } else {
                resp.setBody(bodyAsString);
                }
                
        if (responseHeaders != null) {
            for (string key : responseHeaders.KeySet()) {
                resp.setHeader(key, responseHeaders.get(key));
            }
        }
            return resp;
    }
}