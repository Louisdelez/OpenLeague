package com.riotgames.platform.gameclient.module.services.mail
{
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.gameclient.error.MailError;
   import com.riotgames.platform.gameclient.services.mail.SMTPMailService;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import org.bytearray.smtp.events.SMTPEvent;
   import org.bytearray.smtp.mailer.ISMTPMailer;
   import org.bytearray.smtp.mailer.PipeliningSMTPMailer;
   
   public class SMTPMailServiceImpl implements SMTPMailService
   {
      
      private var onSuccess:Function;
      
      private var onError:Function;
      
      private var mailMessage:Object;
      
      private var onComplete:Function;
      
      private var smtpMailer:ISMTPMailer;
      
      public function SMTPMailServiceImpl()
      {
         super();
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         var _loc2_:MailError = new MailError(0,null,param1);
         this.invokeErrorHandlerIfNecessary(_loc2_);
         this.invokeCompletionHandlerIfNecessary(false);
         this.cleanup();
      }
      
      private function invokeSuccessHandlerIfNecessary() : void
      {
         if(this.onSuccess != null)
         {
            this.onSuccess.apply(null,[]);
         }
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         var _loc2_:MailError = new MailError(0,null,param1);
         this.invokeErrorHandlerIfNecessary(_loc2_);
         this.invokeCompletionHandlerIfNecessary(false);
         this.cleanup();
      }
      
      private function invokeErrorHandlerIfNecessary(param1:MailError) : void
      {
         if(this.onError != null)
         {
            this.onError.apply(null,[param1]);
         }
      }
      
      private function onConnected(param1:SMTPEvent) : void
      {
         if(this.mailMessage.attachments == null || this.mailMessage.attachments.length == 0)
         {
            this.smtpMailer.sendHTMLMail(this.mailMessage.fromAddress,this.mailMessage.toAddress,this.mailMessage.subject,this.mailMessage.htmlBody);
         }
         else
         {
            this.smtpMailer.sendMailWithAttachments(this.mailMessage.fromAddress,this.mailMessage.toAddress,this.mailMessage.subject,this.mailMessage.htmlBody,this.mailMessage.attachments,this.mailMessage.filenames);
         }
      }
      
      private function onSMTPMailSent(param1:SMTPEvent) : void
      {
         this.invokeSuccessHandlerIfNecessary();
         this.invokeCompletionHandlerIfNecessary(true);
         this.cleanup();
      }
      
      private function cleanup() : void
      {
         this.onError = null;
         this.onComplete = null;
         this.onSuccess = null;
         this.mailMessage = null;
         this.smtpMailer.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.smtpMailer.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.smtpMailer.removeEventListener(SMTPEvent.CONNECTED,this.onConnected);
         this.smtpMailer.removeEventListener(SMTPEvent.MAIL_ERROR,this.onSMTPMailError);
         this.smtpMailer.removeEventListener(SMTPEvent.MAIL_SENT,this.onSMTPMailSent);
         this.smtpMailer.close();
         this.smtpMailer = null;
      }
      
      private function onSMTPMailError(param1:SMTPEvent) : void
      {
         var _loc2_:MailError = new MailError(param1.result.code as int,param1.result.message as String,param1);
         this.invokeErrorHandlerIfNecessary(_loc2_);
         this.invokeCompletionHandlerIfNecessary(false);
         this.cleanup();
      }
      
      private function invokeCompletionHandlerIfNecessary(param1:Boolean) : void
      {
         if(this.onComplete != null)
         {
            this.onComplete.apply(null,[param1]);
         }
      }
      
      public function sendMail(param1:String, param2:int, param3:String, param4:String, param5:String, param6:String, param7:Array, param8:Array, param9:Function, param10:Function, param11:Function) : void
      {
         this.smtpMailer = new PipeliningSMTPMailer(null,0);
         this.onSuccess = param9;
         this.onComplete = param10;
         this.onError = param11;
         this.mailMessage = {
            "fromAddress":param3,
            "toAddress":param4,
            "subject":param5,
            "htmlBody":param6,
            "attachments":param7,
            "filenames":param8
         };
         this.smtpMailer.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.smtpMailer.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.smtpMailer.addEventListener(SMTPEvent.CONNECTED,this.onConnected);
         this.smtpMailer.addEventListener(SMTPEvent.MAIL_ERROR,this.onSMTPMailError);
         this.smtpMailer.addEventListener(SMTPEvent.MAIL_SENT,this.onSMTPMailSent);
         this.smtpMailer.connect(param1,param2);
         ServiceLogger.request("smtpMailService","sendMail",[param1,param2,param3,param4,param5,param6,param7,param8]);
      }
   }
}

