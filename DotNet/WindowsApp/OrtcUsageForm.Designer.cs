/**
 * Copyright (c) 2007-2011, Kaazing Corporation. All rights reserved.
 */

﻿namespace Ibt.Ortc.Demo.WindowsApp
{
     partial class OrtcUsageForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.label1 = new System.Windows.Forms.Label();
            this.txtClientChannel = new System.Windows.Forms.TextBox();
            this.txtClientUrl = new System.Windows.Forms.TextBox();
            this.btnConnect = new System.Windows.Forms.Button();
            this.btnDisconnect = new System.Windows.Forms.Button();
            this.btnSend = new System.Windows.Forms.Button();
            this.btnSubscribe = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.txtClientMessage = new System.Windows.Forms.TextBox();
            this.btnUnsubscribe = new System.Windows.Forms.Button();
            this.btnDrawCircle = new System.Windows.Forms.Button();
            this.txtPostAuthAppKey = new System.Windows.Forms.TextBox();
            this.label12 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtClientConnectionMetadata = new System.Windows.Forms.TextBox();
            this.textBoxClusterUrl = new System.Windows.Forms.TextBox();
            this.permissionBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.permissionDataBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.label19 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.chEnableHeartbeat = new System.Windows.Forms.CheckBox();
            this.chkClientIsCluster = new System.Windows.Forms.CheckBox();
            this.btnSendBugilion = new System.Windows.Forms.Button();
            this.txtClientToken = new System.Windows.Forms.TextBox();
            this.label11 = new System.Windows.Forms.Label();
            this.label23 = new System.Windows.Forms.Label();
            this.txtClientAnnouncementSubChannel = new System.Windows.Forms.TextBox();
            this.txtClientChannelSubscribed = new System.Windows.Forms.TextBox();
            this.txtClientAppKey = new System.Windows.Forms.TextBox();
            this.btnIsSubscribed = new System.Windows.Forms.Button();
            this.btnDisablePresence = new System.Windows.Forms.Button();
            this.btnEnablePresence = new System.Windows.Forms.Button();
            this.btnPresence = new System.Windows.Forms.Button();
            this.label21 = new System.Windows.Forms.Label();
            this.label24 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.btnClearLog = new System.Windows.Forms.Button();
            this.txtPostAuthChannel = new System.Windows.Forms.TextBox();
            this.label18 = new System.Windows.Forms.Label();
            this.pnlAuthenticationPost = new System.Windows.Forms.Panel();
            this.chkPostAuthTokenIsPrivate = new System.Windows.Forms.CheckBox();
            this.chkPostAuthIsCluster = new System.Windows.Forms.CheckBox();
            this.txtPostAuthPermission = new System.Windows.Forms.TextBox();
            this.label27 = new System.Windows.Forms.Label();
            this.txtPostAuthPrivateKey = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.txtPostAuthTTL = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.txtPostAuthUrl = new System.Windows.Forms.TextBox();
            this.txtPostAuthToken = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.txtPostParams = new System.Windows.Forms.TextBox();
            this.label15 = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.btnPostPermissions = new System.Windows.Forms.Button();
            this.permissionsDatasourceBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.panel1 = new System.Windows.Forms.Panel();
            this.labelCurrentMessagesPerSecond = new System.Windows.Forms.Label();
            this.labelMessagesPerSecond = new System.Windows.Forms.Label();
            this.txtLog = new System.Windows.Forms.TextBox();
            this.lblCurrentTime = new System.Windows.Forms.Label();
            this.label29 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.permissionBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.permissionDataBindingSource)).BeginInit();
            this.panel2.SuspendLayout();
            this.pnlAuthenticationPost.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.permissionsDatasourceBindingSource)).BeginInit();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(10, 129);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(64, 17);
            this.label1.TabIndex = 29;
            this.label1.Text = "Channel:";
            // 
            // txtClientChannel
            // 
            this.txtClientChannel.Location = new System.Drawing.Point(9, 149);
            this.txtClientChannel.Name = "txtClientChannel";
            this.txtClientChannel.Size = new System.Drawing.Size(173, 20);
            this.txtClientChannel.TabIndex = 31;
            // 
            // txtClientUrl
            // 
            this.txtClientUrl.Location = new System.Drawing.Point(10, 53);
            this.txtClientUrl.Name = "txtClientUrl";
            this.txtClientUrl.Size = new System.Drawing.Size(492, 20);
            this.txtClientUrl.TabIndex = 22;
            // 
            // btnConnect
            // 
            this.btnConnect.Location = new System.Drawing.Point(9, 319);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(93, 28);
            this.btnConnect.TabIndex = 8;
            this.btnConnect.Text = "Connect";
            this.btnConnect.UseVisualStyleBackColor = true;
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // btnDisconnect
            // 
            this.btnDisconnect.Location = new System.Drawing.Point(409, 319);
            this.btnDisconnect.Name = "btnDisconnect";
            this.btnDisconnect.Size = new System.Drawing.Size(93, 28);
            this.btnDisconnect.TabIndex = 9;
            this.btnDisconnect.Text = "Disconnect";
            this.btnDisconnect.UseVisualStyleBackColor = true;
            this.btnDisconnect.Click += new System.EventHandler(this.btnDisconnect_Click);
            // 
            // btnSend
            // 
            this.btnSend.Location = new System.Drawing.Point(209, 319);
            this.btnSend.Name = "btnSend";
            this.btnSend.Size = new System.Drawing.Size(93, 28);
            this.btnSend.TabIndex = 15;
            this.btnSend.Text = "Send";
            this.btnSend.UseVisualStyleBackColor = true;
            this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
            // 
            // btnSubscribe
            // 
            this.btnSubscribe.Location = new System.Drawing.Point(108, 319);
            this.btnSubscribe.Name = "btnSubscribe";
            this.btnSubscribe.Size = new System.Drawing.Size(93, 28);
            this.btnSubscribe.TabIndex = 15;
            this.btnSubscribe.Text = "Subscribe";
            this.btnSubscribe.UseVisualStyleBackColor = true;
            this.btnSubscribe.Click += new System.EventHandler(this.btnSubscribe_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(8, 178);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(69, 17);
            this.label3.TabIndex = 33;
            this.label3.Text = "Message:";
            // 
            // txtClientMessage
            // 
            this.txtClientMessage.Location = new System.Drawing.Point(9, 198);
            this.txtClientMessage.Multiline = true;
            this.txtClientMessage.Name = "txtClientMessage";
            this.txtClientMessage.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtClientMessage.Size = new System.Drawing.Size(493, 63);
            this.txtClientMessage.TabIndex = 34;
            // 
            // btnUnsubscribe
            // 
            this.btnUnsubscribe.Location = new System.Drawing.Point(308, 319);
            this.btnUnsubscribe.Name = "btnUnsubscribe";
            this.btnUnsubscribe.Size = new System.Drawing.Size(93, 28);
            this.btnUnsubscribe.TabIndex = 15;
            this.btnUnsubscribe.Text = "Unsubscribe";
            this.btnUnsubscribe.UseVisualStyleBackColor = true;
            this.btnUnsubscribe.Click += new System.EventHandler(this.btnUnsubscribe_Click);
            // 
            // btnDrawCircle
            // 
            this.btnDrawCircle.Enabled = false;
            this.btnDrawCircle.Location = new System.Drawing.Point(10, 401);
            this.btnDrawCircle.Name = "btnDrawCircle";
            this.btnDrawCircle.Size = new System.Drawing.Size(93, 28);
            this.btnDrawCircle.TabIndex = 15;
            this.btnDrawCircle.Text = "Draw Circle";
            this.btnDrawCircle.UseVisualStyleBackColor = true;
            this.btnDrawCircle.Click += new System.EventHandler(this.btnDrawCircle_Click);
            // 
            // txtPostAuthAppKey
            // 
            this.txtPostAuthAppKey.Location = new System.Drawing.Point(13, 149);
            this.txtPostAuthAppKey.MaxLength = 6;
            this.txtPostAuthAppKey.Name = "txtPostAuthAppKey";
            this.txtPostAuthAppKey.Size = new System.Drawing.Size(128, 20);
            this.txtPostAuthAppKey.TabIndex = 10;
            this.txtPostAuthAppKey.TextChanged += new System.EventHandler(this.txtPostAppKey_TextChanged);
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.Location = new System.Drawing.Point(10, 129);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(109, 17);
            this.label12.TabIndex = 7;
            this.label12.Text = "Application Key:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(330, 82);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(146, 17);
            this.label2.TabIndex = 25;
            this.label2.Text = "Connection Metadata:";
            // 
            // txtClientConnectionMetadata
            // 
            this.txtClientConnectionMetadata.Location = new System.Drawing.Point(333, 102);
            this.txtClientConnectionMetadata.MaxLength = 256;
            this.txtClientConnectionMetadata.Name = "txtClientConnectionMetadata";
            this.txtClientConnectionMetadata.Size = new System.Drawing.Size(169, 20);
            this.txtClientConnectionMetadata.TabIndex = 28;
            // 
            // textBoxClusterUrl
            // 
            this.textBoxClusterUrl.Location = new System.Drawing.Point(22, 96);
            this.textBoxClusterUrl.Name = "textBoxClusterUrl";
            this.textBoxClusterUrl.Size = new System.Drawing.Size(201, 20);
            this.textBoxClusterUrl.TabIndex = 20;
            this.textBoxClusterUrl.Text = "http://107.20.235.150/v1.0/";
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label19.Location = new System.Drawing.Point(209, 28);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(90, 17);
            this.label19.TabIndex = 18;
            this.label19.Text = "Cluster Url:";
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.LightSteelBlue;
            this.panel2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel2.Controls.Add(this.chEnableHeartbeat);
            this.panel2.Controls.Add(this.label2);
            this.panel2.Controls.Add(this.chkClientIsCluster);
            this.panel2.Controls.Add(this.btnSubscribe);
            this.panel2.Controls.Add(this.btnSendBugilion);
            this.panel2.Controls.Add(this.btnDrawCircle);
            this.panel2.Controls.Add(this.txtClientUrl);
            this.panel2.Controls.Add(this.btnUnsubscribe);
            this.panel2.Controls.Add(this.txtClientToken);
            this.panel2.Controls.Add(this.label11);
            this.panel2.Controls.Add(this.btnSend);
            this.panel2.Controls.Add(this.label23);
            this.panel2.Controls.Add(this.txtClientAnnouncementSubChannel);
            this.panel2.Controls.Add(this.txtClientChannelSubscribed);
            this.panel2.Controls.Add(this.txtClientChannel);
            this.panel2.Controls.Add(this.txtClientAppKey);
            this.panel2.Controls.Add(this.btnIsSubscribed);
            this.panel2.Controls.Add(this.btnDisablePresence);
            this.panel2.Controls.Add(this.btnEnablePresence);
            this.panel2.Controls.Add(this.btnPresence);
            this.panel2.Controls.Add(this.btnConnect);
            this.panel2.Controls.Add(this.label21);
            this.panel2.Controls.Add(this.btnDisconnect);
            this.panel2.Controls.Add(this.label24);
            this.panel2.Controls.Add(this.txtClientConnectionMetadata);
            this.panel2.Controls.Add(this.label4);
            this.panel2.Controls.Add(this.txtClientMessage);
            this.panel2.Controls.Add(this.label1);
            this.panel2.Controls.Add(this.label13);
            this.panel2.Controls.Add(this.label8);
            this.panel2.Controls.Add(this.label3);
            this.panel2.Location = new System.Drawing.Point(401, 12);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(516, 458);
            this.panel2.TabIndex = 39;
            // 
            // chEnableHeartbeat
            // 
            this.chEnableHeartbeat.AutoSize = true;
            this.chEnableHeartbeat.Location = new System.Drawing.Point(195, 178);
            this.chEnableHeartbeat.Name = "chEnableHeartbeat";
            this.chEnableHeartbeat.Size = new System.Drawing.Size(109, 17);
            this.chEnableHeartbeat.TabIndex = 37;
            this.chEnableHeartbeat.Text = "Enable Heartbeat";
            this.chEnableHeartbeat.UseVisualStyleBackColor = true;
            // 
            // chkClientIsCluster
            // 
            this.chkClientIsCluster.AutoSize = true;
            this.chkClientIsCluster.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.chkClientIsCluster.Location = new System.Drawing.Point(407, 32);
            this.chkClientIsCluster.Name = "chkClientIsCluster";
            this.chkClientIsCluster.Size = new System.Drawing.Size(85, 21);
            this.chkClientIsCluster.TabIndex = 21;
            this.chkClientIsCluster.Text = "Is Cluster";
            this.chkClientIsCluster.UseVisualStyleBackColor = true;
            // 
            // btnSendBugilion
            // 
            this.btnSendBugilion.Enabled = false;
            this.btnSendBugilion.Location = new System.Drawing.Point(108, 401);
            this.btnSendBugilion.Name = "btnSendBugilion";
            this.btnSendBugilion.Size = new System.Drawing.Size(92, 28);
            this.btnSendBugilion.TabIndex = 15;
            this.btnSendBugilion.Text = "Send thousand messages";
            this.btnSendBugilion.UseVisualStyleBackColor = true;
            this.btnSendBugilion.Click += new System.EventHandler(this.btnSendBugilion_Click);
            // 
            // txtClientToken
            // 
            this.txtClientToken.Location = new System.Drawing.Point(11, 102);
            this.txtClientToken.Name = "txtClientToken";
            this.txtClientToken.Size = new System.Drawing.Size(171, 20);
            this.txtClientToken.TabIndex = 26;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.Location = new System.Drawing.Point(10, 33);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(54, 17);
            this.label11.TabIndex = 20;
            this.label11.Text = "Server:";
            // 
            // label23
            // 
            this.label23.AutoSize = true;
            this.label23.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label23.Location = new System.Drawing.Point(8, 82);
            this.label23.Name = "label23";
            this.label23.Size = new System.Drawing.Size(146, 17);
            this.label23.TabIndex = 23;
            this.label23.Text = "Authentication Token:";
            // 
            // txtClientAnnouncementSubChannel
            // 
            this.txtClientAnnouncementSubChannel.Location = new System.Drawing.Point(194, 149);
            this.txtClientAnnouncementSubChannel.Name = "txtClientAnnouncementSubChannel";
            this.txtClientAnnouncementSubChannel.Size = new System.Drawing.Size(308, 20);
            this.txtClientAnnouncementSubChannel.TabIndex = 32;
            // 
            // txtClientChannelSubscribed
            // 
            this.txtClientChannelSubscribed.Location = new System.Drawing.Point(194, 280);
            this.txtClientChannelSubscribed.Name = "txtClientChannelSubscribed";
            this.txtClientChannelSubscribed.Size = new System.Drawing.Size(128, 20);
            this.txtClientChannelSubscribed.TabIndex = 36;
            // 
            // txtClientAppKey
            // 
            this.txtClientAppKey.Location = new System.Drawing.Point(194, 102);
            this.txtClientAppKey.MaxLength = 6;
            this.txtClientAppKey.Name = "txtClientAppKey";
            this.txtClientAppKey.Size = new System.Drawing.Size(128, 20);
            this.txtClientAppKey.TabIndex = 27;
            // 
            // btnIsSubscribed
            // 
            this.btnIsSubscribed.Location = new System.Drawing.Point(345, 277);
            this.btnIsSubscribed.Name = "btnIsSubscribed";
            this.btnIsSubscribed.Size = new System.Drawing.Size(73, 28);
            this.btnIsSubscribed.TabIndex = 8;
            this.btnIsSubscribed.Text = "Check";
            this.btnIsSubscribed.UseVisualStyleBackColor = true;
            this.btnIsSubscribed.Click += new System.EventHandler(this.btnIsSubscribed_Click);
            // 
            // btnDisablePresence
            // 
            this.btnDisablePresence.Location = new System.Drawing.Point(308, 358);
            this.btnDisablePresence.Name = "btnDisablePresence";
            this.btnDisablePresence.Size = new System.Drawing.Size(194, 28);
            this.btnDisablePresence.TabIndex = 8;
            this.btnDisablePresence.Text = "Disable presence";
            this.btnDisablePresence.UseVisualStyleBackColor = true;
            this.btnDisablePresence.Click += new System.EventHandler(this.btnDisablePresence_Click);
            // 
            // btnEnablePresence
            // 
            this.btnEnablePresence.Location = new System.Drawing.Point(108, 358);
            this.btnEnablePresence.Name = "btnEnablePresence";
            this.btnEnablePresence.Size = new System.Drawing.Size(194, 28);
            this.btnEnablePresence.TabIndex = 8;
            this.btnEnablePresence.Text = "Enable presence";
            this.btnEnablePresence.UseVisualStyleBackColor = true;
            this.btnEnablePresence.Click += new System.EventHandler(this.btnEnablePresence_Click);
            // 
            // btnPresence
            // 
            this.btnPresence.Location = new System.Drawing.Point(9, 358);
            this.btnPresence.Name = "btnPresence";
            this.btnPresence.Size = new System.Drawing.Size(93, 28);
            this.btnPresence.TabIndex = 8;
            this.btnPresence.Text = "Presence";
            this.btnPresence.UseVisualStyleBackColor = true;
            this.btnPresence.Click += new System.EventHandler(this.btnPresence_Click);
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label21.ForeColor = System.Drawing.Color.Navy;
            this.label21.Location = new System.Drawing.Point(10, 10);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(89, 17);
            this.label21.TabIndex = 0;
            this.label21.Text = "Connection";
            // 
            // label24
            // 
            this.label24.AutoSize = true;
            this.label24.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label24.Location = new System.Drawing.Point(192, 82);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(109, 17);
            this.label24.TabIndex = 24;
            this.label24.Text = "Application Key:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(192, 129);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(186, 17);
            this.label4.TabIndex = 30;
            this.label4.Text = "Announcement Subchannel:";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.Location = new System.Drawing.Point(323, 281);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(16, 17);
            this.label13.TabIndex = 10;
            this.label13.Text = "?";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.Location = new System.Drawing.Point(6, 281);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(185, 17);
            this.label8.TabIndex = 35;
            this.label8.Text = "Is subscribed to the channel";
            // 
            // btnClearLog
            // 
            this.btnClearLog.Location = new System.Drawing.Point(807, 191);
            this.btnClearLog.Name = "btnClearLog";
            this.btnClearLog.Size = new System.Drawing.Size(84, 28);
            this.btnClearLog.TabIndex = 7;
            this.btnClearLog.Text = "Clear";
            this.btnClearLog.UseVisualStyleBackColor = true;
            this.btnClearLog.Click += new System.EventHandler(this.btnClearLog_Click);
            // 
            // txtPostAuthChannel
            // 
            this.txtPostAuthChannel.Font = new System.Drawing.Font("Verdana", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPostAuthChannel.Location = new System.Drawing.Point(12, 197);
            this.txtPostAuthChannel.Multiline = true;
            this.txtPostAuthChannel.Name = "txtPostAuthChannel";
            this.txtPostAuthChannel.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtPostAuthChannel.Size = new System.Drawing.Size(223, 71);
            this.txtPostAuthChannel.TabIndex = 15;
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label18.Location = new System.Drawing.Point(11, 178);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(71, 17);
            this.label18.TabIndex = 13;
            this.label18.Text = "Channels:";
            // 
            // pnlAuthenticationPost
            // 
            this.pnlAuthenticationPost.BackColor = System.Drawing.Color.LightSteelBlue;
            this.pnlAuthenticationPost.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlAuthenticationPost.Controls.Add(this.chkPostAuthTokenIsPrivate);
            this.pnlAuthenticationPost.Controls.Add(this.chkPostAuthIsCluster);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostAuthPermission);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostAuthChannel);
            this.pnlAuthenticationPost.Controls.Add(this.label27);
            this.pnlAuthenticationPost.Controls.Add(this.label18);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostAuthPrivateKey);
            this.pnlAuthenticationPost.Controls.Add(this.label5);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostAuthTTL);
            this.pnlAuthenticationPost.Controls.Add(this.label6);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostAuthUrl);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostAuthToken);
            this.pnlAuthenticationPost.Controls.Add(this.label9);
            this.pnlAuthenticationPost.Controls.Add(this.label10);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostParams);
            this.pnlAuthenticationPost.Controls.Add(this.label15);
            this.pnlAuthenticationPost.Controls.Add(this.txtPostAuthAppKey);
            this.pnlAuthenticationPost.Controls.Add(this.label17);
            this.pnlAuthenticationPost.Controls.Add(this.btnPostPermissions);
            this.pnlAuthenticationPost.Controls.Add(this.label12);
            this.pnlAuthenticationPost.Location = new System.Drawing.Point(12, 12);
            this.pnlAuthenticationPost.Name = "pnlAuthenticationPost";
            this.pnlAuthenticationPost.Size = new System.Drawing.Size(383, 458);
            this.pnlAuthenticationPost.TabIndex = 42;
            // 
            // chkPostAuthTokenIsPrivate
            // 
            this.chkPostAuthTokenIsPrivate.AutoSize = true;
            this.chkPostAuthTokenIsPrivate.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.chkPostAuthTokenIsPrivate.Location = new System.Drawing.Point(281, 81);
            this.chkPostAuthTokenIsPrivate.Name = "chkPostAuthTokenIsPrivate";
            this.chkPostAuthTokenIsPrivate.Size = new System.Drawing.Size(85, 21);
            this.chkPostAuthTokenIsPrivate.TabIndex = 5;
            this.chkPostAuthTokenIsPrivate.Text = "Is Private";
            this.chkPostAuthTokenIsPrivate.UseVisualStyleBackColor = true;
            this.chkPostAuthTokenIsPrivate.CheckedChanged += new System.EventHandler(this.chkPostAuthTokenIsPrivate_CheckedChanged);
            // 
            // chkPostAuthIsCluster
            // 
            this.chkPostAuthIsCluster.AutoSize = true;
            this.chkPostAuthIsCluster.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.chkPostAuthIsCluster.Location = new System.Drawing.Point(281, 33);
            this.chkPostAuthIsCluster.Name = "chkPostAuthIsCluster";
            this.chkPostAuthIsCluster.Size = new System.Drawing.Size(85, 21);
            this.chkPostAuthIsCluster.TabIndex = 2;
            this.chkPostAuthIsCluster.Text = "Is Cluster";
            this.chkPostAuthIsCluster.UseVisualStyleBackColor = true;
            // 
            // txtPostAuthPermission
            // 
            this.txtPostAuthPermission.Font = new System.Drawing.Font("Verdana", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPostAuthPermission.Location = new System.Drawing.Point(250, 197);
            this.txtPostAuthPermission.Multiline = true;
            this.txtPostAuthPermission.Name = "txtPostAuthPermission";
            this.txtPostAuthPermission.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtPostAuthPermission.Size = new System.Drawing.Size(116, 71);
            this.txtPostAuthPermission.TabIndex = 16;
            // 
            // label27
            // 
            this.label27.AutoSize = true;
            this.label27.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label27.Location = new System.Drawing.Point(247, 178);
            this.label27.Name = "label27";
            this.label27.Size = new System.Drawing.Size(88, 17);
            this.label27.TabIndex = 14;
            this.label27.Text = "Permissions:";
            // 
            // txtPostAuthPrivateKey
            // 
            this.txtPostAuthPrivateKey.Location = new System.Drawing.Point(154, 149);
            this.txtPostAuthPrivateKey.MaxLength = 12;
            this.txtPostAuthPrivateKey.Name = "txtPostAuthPrivateKey";
            this.txtPostAuthPrivateKey.Size = new System.Drawing.Size(115, 20);
            this.txtPostAuthPrivateKey.TabIndex = 11;
            this.txtPostAuthPrivateKey.Text = "YOUR_PRIVATE_KEY";
            this.txtPostAuthPrivateKey.TextChanged += new System.EventHandler(this.txtPostPrivateKey_TextChanged);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(151, 129);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(84, 17);
            this.label5.TabIndex = 8;
            this.label5.Text = "Private Key:";
            // 
            // txtPostAuthTTL
            // 
            this.txtPostAuthTTL.Location = new System.Drawing.Point(282, 149);
            this.txtPostAuthTTL.MaxLength = 6;
            this.txtPostAuthTTL.Name = "txtPostAuthTTL";
            this.txtPostAuthTTL.Size = new System.Drawing.Size(84, 20);
            this.txtPostAuthTTL.TabIndex = 12;
            this.txtPostAuthTTL.Text = "1400";
            this.txtPostAuthTTL.TextChanged += new System.EventHandler(this.txtPostTTL_TextChanged);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(279, 129);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(38, 17);
            this.label6.TabIndex = 9;
            this.label6.Text = "TTL:";
            // 
            // txtPostAuthUrl
            // 
            this.txtPostAuthUrl.Location = new System.Drawing.Point(12, 54);
            this.txtPostAuthUrl.Name = "txtPostAuthUrl";
            this.txtPostAuthUrl.Size = new System.Drawing.Size(354, 20);
            this.txtPostAuthUrl.TabIndex = 3;
            // 
            // txtPostAuthToken
            // 
            this.txtPostAuthToken.Location = new System.Drawing.Point(14, 102);
            this.txtPostAuthToken.Name = "txtPostAuthToken";
            this.txtPostAuthToken.Size = new System.Drawing.Size(352, 20);
            this.txtPostAuthToken.TabIndex = 6;
            this.txtPostAuthToken.Text = "3afxcv4ymzzsfmovdon22kmh";
            this.txtPostAuthToken.TextChanged += new System.EventHandler(this.txtPostAuthToken_TextChanged);
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.Location = new System.Drawing.Point(10, 34);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(54, 17);
            this.label9.TabIndex = 1;
            this.label9.Text = "Server:";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.Location = new System.Drawing.Point(12, 82);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(146, 17);
            this.label10.TabIndex = 4;
            this.label10.Text = "Authentication Token:";
            // 
            // txtPostParams
            // 
            this.txtPostParams.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPostParams.Location = new System.Drawing.Point(12, 297);
            this.txtPostParams.Multiline = true;
            this.txtPostParams.Name = "txtPostParams";
            this.txtPostParams.ReadOnly = true;
            this.txtPostParams.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtPostParams.Size = new System.Drawing.Size(354, 51);
            this.txtPostParams.TabIndex = 18;
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label15.ForeColor = System.Drawing.Color.Navy;
            this.label15.Location = new System.Drawing.Point(9, 7);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(149, 17);
            this.label15.TabIndex = 0;
            this.label15.Text = "Post Authentication";
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label17.Location = new System.Drawing.Point(12, 277);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(116, 17);
            this.label17.TabIndex = 17;
            this.label17.Text = "Post parameters:";
            // 
            // btnPostPermissions
            // 
            this.btnPostPermissions.Location = new System.Drawing.Point(267, 358);
            this.btnPostPermissions.Name = "btnPostPermissions";
            this.btnPostPermissions.Size = new System.Drawing.Size(99, 28);
            this.btnPostPermissions.TabIndex = 19;
            this.btnPostPermissions.Text = "Post";
            this.btnPostPermissions.UseVisualStyleBackColor = true;
            this.btnPostPermissions.Click += new System.EventHandler(this.btnPostPermissions_Click);
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.LightSteelBlue;
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.labelCurrentMessagesPerSecond);
            this.panel1.Controls.Add(this.labelMessagesPerSecond);
            this.panel1.Controls.Add(this.txtLog);
            this.panel1.Controls.Add(this.lblCurrentTime);
            this.panel1.Controls.Add(this.btnClearLog);
            this.panel1.Controls.Add(this.label29);
            this.panel1.Controls.Add(this.label7);
            this.panel1.Location = new System.Drawing.Point(12, 476);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(905, 232);
            this.panel1.TabIndex = 46;
            // 
            // labelCurrentMessagesPerSecond
            // 
            this.labelCurrentMessagesPerSecond.AutoSize = true;
            this.labelCurrentMessagesPerSecond.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelCurrentMessagesPerSecond.Location = new System.Drawing.Point(652, 17);
            this.labelCurrentMessagesPerSecond.Name = "labelCurrentMessagesPerSecond";
            this.labelCurrentMessagesPerSecond.Size = new System.Drawing.Size(14, 13);
            this.labelCurrentMessagesPerSecond.TabIndex = 49;
            this.labelCurrentMessagesPerSecond.Text = "0";
            // 
            // labelMessagesPerSecond
            // 
            this.labelMessagesPerSecond.AutoSize = true;
            this.labelMessagesPerSecond.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelMessagesPerSecond.Location = new System.Drawing.Point(562, 15);
            this.labelMessagesPerSecond.Name = "labelMessagesPerSecond";
            this.labelMessagesPerSecond.Size = new System.Drawing.Size(95, 17);
            this.labelMessagesPerSecond.TabIndex = 48;
            this.labelMessagesPerSecond.Text = "Messages / s:";
            // 
            // txtLog
            // 
            this.txtLog.Location = new System.Drawing.Point(12, 41);
            this.txtLog.Multiline = true;
            this.txtLog.Name = "txtLog";
            this.txtLog.ReadOnly = true;
            this.txtLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtLog.Size = new System.Drawing.Size(879, 139);
            this.txtLog.TabIndex = 47;
            // 
            // lblCurrentTime
            // 
            this.lblCurrentTime.AutoSize = true;
            this.lblCurrentTime.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblCurrentTime.Location = new System.Drawing.Point(837, 17);
            this.lblCurrentTime.Name = "lblCurrentTime";
            this.lblCurrentTime.Size = new System.Drawing.Size(56, 13);
            this.lblCurrentTime.TabIndex = 12;
            this.lblCurrentTime.Text = "currTime";
            // 
            // label29
            // 
            this.label29.AutoSize = true;
            this.label29.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label29.ForeColor = System.Drawing.Color.Navy;
            this.label29.Location = new System.Drawing.Point(9, 15);
            this.label29.Name = "label29";
            this.label29.Size = new System.Drawing.Size(35, 17);
            this.label29.TabIndex = 0;
            this.label29.Text = "Log";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(747, 15);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(94, 17);
            this.label7.TabIndex = 0;
            this.label7.Text = "Current Time:";
            // 
            // timer1
            // 
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // OrtcUsageForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.ClientSize = new System.Drawing.Size(930, 717);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.pnlAuthenticationPost);
            this.Name = "OrtcUsageForm";
            this.Text = "ORTC .Net Client";
            this.Load += new System.EventHandler(this.OrtcUsageForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.permissionBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.permissionDataBindingSource)).EndInit();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.pnlAuthenticationPost.ResumeLayout(false);
            this.pnlAuthenticationPost.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.permissionsDatasourceBindingSource)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtClientChannel;
        private System.Windows.Forms.TextBox txtClientUrl;
        private System.Windows.Forms.Button btnConnect;
        private System.Windows.Forms.Button btnDisconnect;
        private System.Windows.Forms.Button btnSend;
        private System.Windows.Forms.Button btnSubscribe;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtClientMessage;
        private System.Windows.Forms.Button btnUnsubscribe;
        private System.Windows.Forms.Button btnDrawCircle;
        private System.Windows.Forms.TextBox txtPostAuthAppKey;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.BindingSource permissionsDatasourceBindingSource;
        private System.Windows.Forms.BindingSource permissionBindingSource;
        private System.Windows.Forms.BindingSource permissionDataBindingSource;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtClientConnectionMetadata;
        private System.Windows.Forms.TextBox textBoxClusterUrl;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.Panel pnlAuthenticationPost;
        private System.Windows.Forms.TextBox txtPostAuthPrivateKey;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtPostAuthTTL;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txtPostAuthToken;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.TextBox txtPostParams;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.TextBox txtPostAuthUrl;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Button btnPostPermissions;
        private System.Windows.Forms.TextBox txtPostAuthChannel;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Button btnClearLog;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.TextBox txtClientToken;
        private System.Windows.Forms.Label label23;
        private System.Windows.Forms.TextBox txtClientAppKey;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.TextBox txtPostAuthPermission;
        private System.Windows.Forms.Label label27;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label29;
        private System.Windows.Forms.Button btnSendBugilion;
        private System.Windows.Forms.CheckBox chkPostAuthTokenIsPrivate;
        private System.Windows.Forms.CheckBox chkPostAuthIsCluster;
        private System.Windows.Forms.CheckBox chkClientIsCluster;
        private System.Windows.Forms.Label lblCurrentTime;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.TextBox txtClientAnnouncementSubChannel;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtLog;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtClientChannelSubscribed;
        private System.Windows.Forms.Button btnIsSubscribed;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label labelCurrentMessagesPerSecond;
        private System.Windows.Forms.Label labelMessagesPerSecond;
        private System.Windows.Forms.Button btnPresence;
        private System.Windows.Forms.Button btnDisablePresence;
        private System.Windows.Forms.Button btnEnablePresence;
        private System.Windows.Forms.CheckBox chEnableHeartbeat;
    }
}

