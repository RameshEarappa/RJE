codeunit 50003 "Invoke Service"
{
    trigger OnRun()
    begin
        case IntegrationFunction of
            IntegrationFunction::"Invoke Webservice":
                begin
                    InvokeWebservice();
                end;
        end;
    end;

    local procedure InvokeWebservice()
    var
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        HttpHeadrs: HttpHeaders;
        HttpContent: HttpContent;
        ResponseJsonObject: JsonObject;
    begin
        Clear(Response);
        IsSuccess := false;
        HttpClient.SetBaseAddress(URL);
        HttpContent.WriteFrom(BodyText);
        HttpContent.GetHeaders(HttpHeadrs);
        HttpHeadrs.Remove('Content-Type');
        HttpHeadrs.Add('Content-Type', 'text/xml; charset=utf-8');
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        HttpClient.DefaultRequestHeaders.TryAddWithoutValidation('Content-Type', 'text/xml; charset=utf-8');
        if HttpClient.Post(URL, HttpContent, HttpResponse) then begin
            if HttpResponse.IsSuccessStatusCode() then begin
                HttpResponse.Content().ReadAs(Response);
                IsSuccess := true;
            end else begin
                HttpResponse.Content().ReadAs(Response);
                IsSuccess := false;
            end;
        end else
            Error('Something went wrong while connecting SFA server. %1', HttpResponse.ReasonPhrase)
    end;

    procedure GetResponse(Var IsSuccessp: Boolean; var Responsep: Text)
    begin
        IsSuccessp := IsSuccess;
        Responsep := Response;
    end;

    procedure SetWebseriveProperties(URLP: Text; BodyTextP: Text)
    begin
        Clear(URL);
        Clear(BodyText);
        URL := URLP;
        BodyText := BodyTextP;
    end;

    procedure SetIntegrationFunction(FunctionP: Enum "Integration Function")
    begin
        Clear(IntegrationFunction);
        IntegrationFunction := FunctionP;
    end;

    var
        IntegrationFunction: Enum "Integration Function";
        URL: Text;
        BodyText: Text;
        Response: Text;
        IsSuccess: Boolean;
}