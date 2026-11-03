package org.bytearray.smtp.mailer
{
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import org.bytearray.smtp.crypto.MD5;
   import org.bytearray.smtp.encoding.Base64;
   import org.bytearray.smtp.events.SMTPEvent;
   
   public class PipeliningSMTPMailer extends AbstractSMTPMailer implements ISMTPMailer
   {
      
      private var mailMessage:Object;
      
      public function PipeliningSMTPMailer(param1:String = null, param2:int = 0)
      {
         super(param1,param2);
      }
      
      override protected function handleAuthenticationResponse(param1:Object) : void
      {
         var _loc3_:SMTPEvent = null;
         var _loc2_:Number = param1.code as Number;
         switch(_loc2_)
         {
            case AbstractSMTPMailer.AUTHENTICATED:
               _loc3_ = new SMTPEvent(SMTPEvent.AUTHENTICATED,param1);
               break;
            case AbstractSMTPMailer.AUTHENTICATION_FAILED:
               _loc3_ = new SMTPEvent(SMTPEvent.AUTHENTICATION_FAILED,param1);
               break;
            default:
               super.handleAuthenticationResponse(param1);
         }
         if(_loc3_ != null)
         {
            this.dispatchEvent(_loc3_);
            this.currentState = null;
         }
      }
      
      private function internalSendMailWithoutAttachments() : void
      {
         var _loc1_:String = "From: " + this.mailMessage.from + "\r\n";
         _loc1_ += "To: " + this.mailMessage.to + "\r\n";
         _loc1_ += "Subject: " + this.mailMessage.subject + "\r\n";
         _loc1_ += "Mime-Version: 1.0\r\n";
         _loc1_ += "Content-Type: text/html; charset=UTF-8; format=flowed\r\n";
         _loc1_ += "\r\n";
         _loc1_ += this.mailMessage.body + "\r\n";
         _loc1_ += ".\r\n";
         this.writeUTFBytes(_loc1_);
         flush();
      }
      
      private function isSendingAttachments() : Boolean
      {
         return this.mailMessage.attachments != null;
      }
      
      public function sendHTMLMail(param1:String, param2:String, param3:String, param4:String) : void
      {
         var commandString:String = null;
         var from:String = param1;
         var to:String = param2;
         var subject:String = param3;
         var body:String = param4;
         try
         {
            this.currentState = AbstractSMTPMailer.SENDING_EMAIL;
            this.mailMessage = {
               "from":from,
               "to":to,
               "subject":subject,
               "body":body
            };
            commandString = "HELO " + this.host + "\r\n";
            commandString += "MAIL FROM: <" + from + ">\r\n";
            commandString += "RCPT TO: <" + to + ">\r\n";
            commandString += "DATA\r\n";
            this.writeUTFBytes(commandString);
            this.flush();
         }
         catch(pError:Error)
         {
            trace("Error : Socket error, please check the sendHTMLMail() method parameters");
            trace("Arguments : " + arguments);
         }
      }
      
      private function internalSendMailWithAttachments() : void
      {
         var _loc6_:ByteArray = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc1_:Array = this.mailMessage.attachments as Array;
         var _loc2_:Array = this.mailMessage.fileNames as Array;
         var _loc3_:String = "From: " + this.mailMessage.from + "\r\n";
         _loc3_ += "To: " + this.mailMessage.to + "\r\n";
         _loc3_ += "Date : " + new Date().toString() + "\r\n";
         _loc3_ += "Subject: " + this.mailMessage.subject + "\r\n";
         _loc3_ += "Mime-Version: 1.0\r\n";
         var _loc4_:String = MD5.hash(String(getTimer()));
         _loc3_ += "Content-Type: multipart/mixed; boundary=------------" + _loc4_ + "\r\n";
         _loc3_ += "\r\n";
         _loc3_ += "This is a multi-part message in MIME format.\r\n";
         _loc3_ += "--------------" + _loc4_ + "\r\n";
         _loc3_ += "Content-Type: text/html; charset=UTF-8; format=flowed\r\n";
         _loc3_ += "\r\n";
         _loc3_ += this.mailMessage.body + "\r\n";
         var _loc5_:int = 0;
         while(_loc5_ < _loc1_.length)
         {
            _loc6_ = _loc1_[_loc5_] as ByteArray;
            _loc7_ = _loc2_[_loc5_] as String;
            _loc3_ += "--------------" + _loc4_ + "\r\n";
            _loc3_ += getContentTypeHeaders(_loc6_,_loc7_);
            _loc3_ += "Content-Transfer-Encoding: base64\r\n";
            _loc3_ += "\r\n";
            _loc8_ = Base64.encode64(_loc6_,true);
            _loc3_ += _loc8_ + "\r\n";
            _loc5_++;
         }
         _loc3_ += "--------------" + _loc4_ + "-\r\n";
         _loc3_ += ".\r\n";
         this.writeUTFBytes(_loc3_);
         flush();
      }
      
      public function sendMailWithAttachments(param1:String, param2:String, param3:String, param4:String, param5:Array, param6:Array) : void
      {
         var commandString:String = null;
         var from:String = param1;
         var to:String = param2;
         var subject:String = param3;
         var body:String = param4;
         var attachments:Array = param5;
         var fileNames:Array = param6;
         try
         {
            this.currentState = AbstractSMTPMailer.SENDING_EMAIL;
            this.mailMessage = {
               "from":from,
               "to":to,
               "subject":subject,
               "body":body,
               "attachments":attachments,
               "fileNames":fileNames
            };
            commandString = "HELO " + this.host + "\r\n";
            commandString += "MAIL FROM: <" + from + ">\r\n";
            commandString += "RCPT TO: <" + to + ">\r\n";
            commandString += "DATA\r\n";
            this.writeUTFBytes(commandString);
            this.flush();
         }
         catch(pError:Error)
         {
            trace("Error : Socket error, please check the sendAttachedMail() method parameters");
            trace("Arguments : " + arguments);
         }
      }
      
      public function authenticate(param1:String, param2:String) : void
      {
         this.currentState = AbstractSMTPMailer.AUTHENTICATING;
         var _loc3_:String = "EHLO " + this.host + "\r\n";
         _loc3_ += "AUTH LOGIN\r\n";
         _loc3_ += Base64.encode64String(param1) + "\r\n";
         _loc3_ += Base64.encode64String(param2) + "\r\n";
         this.writeUTFBytes(_loc3_);
         flush();
      }
      
      override protected function handleSendingEmailResponse(param1:Object) : void
      {
         var _loc4_:SMTPEvent = null;
         var _loc2_:Number = param1.code as Number;
         var _loc3_:String = param1.message.toLowerCase() as String;
         switch(_loc2_)
         {
            case AbstractSMTPMailer.ACTION_OK:
               if(_loc3_.indexOf("queued") >= 0 || _loc3_.indexOf("accepted") >= 0 || _loc3_.indexOf("qp") >= 0)
               {
                  _loc4_ = new SMTPEvent(SMTPEvent.MAIL_SENT,param1);
               }
               break;
            case AbstractSMTPMailer.DATA:
               if(this.isSendingAttachments())
               {
                  this.internalSendMailWithAttachments();
               }
               else
               {
                  this.internalSendMailWithoutAttachments();
               }
               break;
            default:
               super.handleSendingEmailResponse(param1);
         }
         if(_loc4_ != null)
         {
            this.dispatchEvent(_loc4_);
            this.currentState = null;
         }
      }
   }
}

