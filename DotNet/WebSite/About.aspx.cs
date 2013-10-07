using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class About : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Get the realtime client from your application context
        var ortcClient = (Ibt.Ortc.Api.Extensibility.OrtcClient)Application["RealtimeClient"];

        ortcClient.Send("MyChannel", "Client navigated to tab about"); 
    }
}
