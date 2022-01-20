codeunit 50015 "Send Notification"
{
    trigger OnRun()
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        RecUserSetup: Record "User Setup";
        ToEmailList: List of [Text];
    begin
        Clear(RecUserSetup);
        RecUserSetup.SetRange("Enable Error Notification", true);
        RecUserSetup.SetFilter("E-Mail", '<>%1', '');
        if RecUserSetup.FindSet() then begin
            Clear(ToEmailList);
            repeat
                ToEmailList.Add(RecUserSetup."E-Mail");
            until RecUserSetup.Next() = 0;
        end;
        EmailMessage.Create(ToEmailList, Subject, GetBody().ToText(), true);
        Email.Send(EmailMessage);
    end;

    procedure InitializeValues(Subjectp: Text; FunctionNamep: Text; IDp: Text; Errorp: Text; URLp: Text)
    begin
        FunctionName := FunctionNamep;
        ID := IDp;
        Error := Errorp;
        URL := URLp;
        Subject := Subjectp;
    end;

    local procedure GetBody(): TextBuilder
    var
        EmailBody: TextBuilder;
    begin
        //Style
        EmailBody.Append('<style>@font-face	{font-family:Helvetica;        panose-1:2 11 6 4 2 2 2 2 2 4;}@font-face	{font-family:"Cambria Math";	panose-1:2 4 5 3 5 4 6 3 2 4;}@font-face	{font-family:Calibri;	panose-1:2 15 5 2 2 2 4 3 2 4;}@font-face	{font-family:"Segoe UI";	panose-1:2 11 5 2 4 2 4 2 2 3;} p.MsoNormal, li.MsoNormal, div.MsoNormal	{margin:0in;	margin-bottom:.0001pt;	font-size:11.0pt;	font-family:"Calibri",sans-serif;}a:link, span.MsoHyperlink	{mso-style-priority:99;	color:#0563C1;	text-decoration:underline;}a:visited, span.MsoHyperlinkFollowed	{mso-style-priority:99;	color:#954F72;	text-decoration:underline;}p.msonormal0, li.msonormal0, div.msonormal00	{mso-style-name:msonormal;	mso-margin-top-alt:auto;	margin-right:0in;	mso-margin-bottom-alt:auto;	margin-left:0in;	font-size:11.0pt;	font-family:"Calibri",sans-serif;}span.EmailStyle18	{mso-style-type:personal;	font-family:"Calibri",sans-serif;	color:windowtext;}span.EmailStyle19	{mso-style-type:personal-reply;	font-family:"Calibri",sans-serif;	color:windowtext;}.MsoChpDefault	{mso-style-type:export-only;	font-size:10.0pt;} @page WordSection1{     size:8.5in 11.0in;     margin:1.0in 1.0in 1.0in 1.0in;}div.WordSection1	{page:WordSection1;}@list l0	{mso-list-id:652948990;	mso-list-template-ids:414455188;}@list l1	{mso-list-id:1383752550;	mso-list-template-ids:612022788;}@list l1:level1	{mso-level-tab-stop:.5in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level2	{mso-level-tab-stop:1.0in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level3	{mso-level-tab-stop:1.5in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level4	{mso-level-tab-stop:2.0in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level5	{mso-level-tab-stop:2.5in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level6	{mso-level-tab-stop:3.0in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level7	{mso-level-tab-stop:3.5in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level8	{mso-level-tab-stop:4.0in;	mso-level-number-position:left;	text-indent:-.25in;}@list l1:level9	{mso-level-tab-stop:4.5in;	mso-level-number-position:left;	text-indent:-.25in;}ol	{margin-bottom:0in;}ul	{margin-bottom:0in;} </style>');
        //Body Text
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black">Hi, <o:p></o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black"><o:p>&nbsp;</o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black">This is to inform you that there is an Error occurred while processing  ' + FunctionName + ' in Business Central. <o:p></o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black"><o:p>&nbsp;</o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black">Please find the Details below:<o:p></o:p></span></p>');
        if ID <> '' then
            EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black">No. : ' + ID + '<o:p></o:p></span> </p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black">Error Description : <i Style=Color:Red;>' + Error + '<i><o:p></o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black"><o:p>&nbsp;</o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black">  <a href="' + URL + '"> Please click here to open related document in Business Central. </a><o:p></o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black"><o:p>&nbsp;</o:p></span></p>');
        EmailBody.Append('<p class=MsoNormal><i Style=Color:Black;><span style="font-size:12.0pt;font-family:"Times New Roman",serif;color:black">This message is sent by the Business Central ERP.</span></i></p>');
        exit(EmailBody);
    end;

    var
        Subject, FunctionName, ID, Error, URL : Text;
}
