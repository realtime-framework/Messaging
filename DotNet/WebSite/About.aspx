<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="About.aspx.cs" Inherits="About" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h2>
        About
    </h2>
    <p>
        <p>
            In this Realtime sample a message was sent to channel MyChannel saying "Client navigated to tab about".<br />
            Use <a href="http://console.realtime.co" target="_blank">http://console.realtime.co</a> in another browser window and subscribe the channel to receive the sent message.
        </p>
    </p>
</asp:Content>
