package org.bytearray.smtp.mailer
{
   import flash.events.IEventDispatcher;
   
   public interface ISMTPMailer extends IEventDispatcher
   {
      
      function connect(param1:String, param2:int) : void;
      
      function authenticate(param1:String, param2:String) : void;
      
      function close() : void;
      
      function sendHTMLMail(param1:String, param2:String, param3:String, param4:String) : void;
      
      function sendMailWithAttachments(param1:String, param2:String, param3:String, param4:String, param5:Array, param6:Array) : void;
   }
}

