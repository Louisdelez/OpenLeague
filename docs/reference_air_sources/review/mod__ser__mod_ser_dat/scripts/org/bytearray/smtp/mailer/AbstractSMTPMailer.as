package org.bytearray.smtp.mailer
{
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.bytearray.smtp.events.SMTPEvent;
   
   public class AbstractSMTPMailer extends Socket
   {
      
      protected static const ACTION_OK:Number = 250;
      
      protected static const AUTHENTICATED:Number = 235;
      
      protected static const AUTHENTICATION_FAILED:Number = 535;
      
      protected static const DISCONNECTED:Number = 221;
      
      protected static const READY:Number = 220;
      
      protected static const DATA:Number = 354;
      
      protected static const BAD_SEQUENCE:Number = 503;
      
      protected static const LOGIN_CREDENTIALS_REQUESTED:Number = 334;
      
      protected static const PNG:Number = 2303741511;
      
      protected static const JPEG:Number = 65496;
      
      protected static const AUTHENTICATING:String = "authenticating";
      
      protected static const SENDING_EMAIL:String = "sending";
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      protected var currentState:String;
      
      protected var host:String;
      
      public function AbstractSMTPMailer(param1:String = null, param2:int = 0)
      {
         super(param1,param2);
         this.host = param1;
         this.addEventListener(ProgressEvent.SOCKET_DATA,onSocketData);
      }
      
      protected function handleAuthenticationResponse(param1:Object) : void
      {
      }
      
      protected function getContentTypeHeaders(param1:ByteArray, param2:String) : String
      {
         param1.position = 0;
         var _loc3_:String = null;
         if(param1.readUnsignedInt() == AbstractSMTPMailer.PNG)
         {
            _loc3_ = "Content-Type: image/png; name=" + param2 + "\r\n";
            return _loc3_ + ("Content-Disposition: attachment filename=" + param2 + "\r\n");
         }
         param1.position = 0;
         if(param1.readUnsignedShort() == AbstractSMTPMailer.JPEG)
         {
            _loc3_ = "Content-Type: image/jpeg; name=" + param2 + "\r\n";
            return _loc3_ + ("Content-Disposition: attachment filename=" + param2 + "\r\n");
         }
         _loc3_ = "Content-Type: application/octet-stream; name=" + param2 + "\r\n";
         return _loc3_ + ("Content-Disposition: attachment filename=" + param2 + "\r\n");
      }
      
      protected function handleSendingEmailResponse(param1:Object) : void
      {
         var _loc2_:SMTPEvent = new SMTPEvent(SMTPEvent.MAIL_ERROR,param1);
         this.dispatchEvent(_loc2_);
      }
      
      protected function onSocketData(param1:ProgressEvent) : void
      {
         var _loc8_:SMTPEvent = null;
         var _loc2_:String = this.readUTFBytes(this.bytesAvailable);
         var _loc3_:RegExp = /^\d{3}/img;
         var _loc4_:Array = new Array();
         var _loc5_:Object = _loc3_.exec(_loc2_);
         while(_loc5_ != null)
         {
            _loc4_.push(_loc5_[0]);
            _loc5_ = _loc3_.exec(_loc2_);
         }
         var _loc6_:Number = Number(_loc4_[_loc4_.length - 1]);
         var _loc7_:Object = {
            "code":_loc6_,
            "message":_loc2_
         };
         switch(this.currentState)
         {
            case AbstractSMTPMailer.AUTHENTICATING:
               this.handleAuthenticationResponse(_loc7_);
               break;
            case AbstractSMTPMailer.SENDING_EMAIL:
               this.handleSendingEmailResponse(_loc7_);
               break;
            default:
               if(_loc6_ == AbstractSMTPMailer.READY)
               {
                  _loc8_ = new SMTPEvent(SMTPEvent.CONNECTED,_loc7_);
                  this.dispatchEvent(_loc8_);
               }
         }
      }
   }
}

