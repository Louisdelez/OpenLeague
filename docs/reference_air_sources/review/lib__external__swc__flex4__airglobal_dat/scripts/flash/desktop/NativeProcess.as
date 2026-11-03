package flash.desktop
{
   import flash.errors.*;
   import flash.events.EventDispatcher;
   import flash.filesystem.File;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [native(cls="NativeProcessClass",instance="NativeProcessObject",methods="auto")]
   [Version("air2.0")]
   [Event(name="exit",type="flash.events.NativeProcessExitEvent")]
   [Event(name="standardInputIoError",type="flash.events.IOErrorEvent")]
   [Event(name="standardOutputIoError",type="flash.events.IOErrorEvent")]
   [Event(name="standardErrorIoError",type="flash.events.IOErrorEvent")]
   [Event(name="standardInputClose",type="flash.events.Event")]
   [Event(name="standardInputProgress",type="flash.events.ProgressEvent")]
   [Event(name="standardErrorClose",type="flash.events.Event")]
   [Event(name="standardErrorData",type="flash.events.ProgressEvent")]
   [Event(name="standardOutputClose",type="flash.events.Event")]
   [Event(name="standardOutputData",type="flash.events.ProgressEvent")]
   public class NativeProcess extends EventDispatcher
   {
      
      public function NativeProcess()
      {
         super();
      }
      
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      [API("678")]
      internal static native function isValidExecutable(param1:File) : Boolean;
      
      public native function closeInput() : void;
      
      public native function get running() : Boolean;
      
      public native function get standardError() : IDataInput;
      
      public native function get standardInput() : IDataOutput;
      
      public native function get standardOutput() : IDataInput;
      
      public function start(info:NativeProcessStartupInfo) : void
      {
         if(this.running)
         {
            Error.throwError(IllegalOperationError,3213);
         }
         if(info.executable == null || !isValidExecutable(info.executable))
         {
            Error.throwError(ArgumentError,3214);
         }
         var workingDirString:String = "";
         if(info.workingDirectory != null)
         {
            if(info.workingDirectory.exists == false || info.workingDirectory.isDirectory == false)
            {
               Error.throwError(ArgumentError,3215);
            }
            workingDirString = info.workingDirectory.nativePath;
         }
         this.internalStart(info.executable.nativePath,info.arguments,workingDirString);
      }
      
      private function escapeArgumentIfNeeded(orignalArgument:String) : String
      {
         var newArgument:String = orignalArgument;
         var QUOTE:String = "\"";
         var QUOTEPATTERN:RegExp = /\"/g;
         var SPACEPATTERN:RegExp = / /g;
         newArgument = newArgument.replace(QUOTEPATTERN,"\\\"");
         if(newArgument.search(SPACEPATTERN) != -1)
         {
            newArgument = QUOTE + newArgument + QUOTE;
         }
         return newArgument;
      }
      
      public native function exit(param1:Boolean = false) : void;
      
      private native function internalStart(param1:String, param2:Vector.<String>, param3:String) : void;
   }
}

import flash.utils.*;

[native(cls="InboundPipeClass",instance="InboundPipeObject",methods="auto")]
class InboundPipe implements IDataInput
{
   
   public function InboundPipe()
   {
      super();
   }
   
   public native function readBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void;
   
   public native function readBoolean() : Boolean;
   
   public native function readByte() : int;
   
   public native function readUnsignedByte() : uint;
   
   public native function readShort() : int;
   
   public native function readUnsignedShort() : uint;
   
   public native function readInt() : int;
   
   public native function readUnsignedInt() : uint;
   
   public native function readFloat() : Number;
   
   public native function readDouble() : Number;
   
   public native function readMultiByte(param1:uint, param2:String) : String;
   
   public native function readUTF() : String;
   
   public native function readUTFBytes(param1:uint) : String;
   
   public native function get bytesAvailable() : uint;
   
   public native function readObject() : *;
   
   public native function get objectEncoding() : uint;
   
   public native function set objectEncoding(param1:uint) : void;
   
   public native function get endian() : String;
   
   public native function set endian(param1:String) : void;
}

[native(cls="OutboundPipeClass",instance="OutboundPipeObject",methods="auto")]
class OutboundPipe implements IDataOutput
{
   
   public function OutboundPipe()
   {
      super();
   }
   
   public native function writeBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void;
   
   public native function writeBoolean(param1:Boolean) : void;
   
   public native function writeByte(param1:int) : void;
   
   public native function writeShort(param1:int) : void;
   
   public native function writeInt(param1:int) : void;
   
   public native function writeUnsignedInt(param1:uint) : void;
   
   public native function writeFloat(param1:Number) : void;
   
   public native function writeDouble(param1:Number) : void;
   
   public native function writeMultiByte(param1:String, param2:String) : void;
   
   public native function writeUTF(param1:String) : void;
   
   public native function writeUTFBytes(param1:String) : void;
   
   public native function writeObject(param1:*) : void;
   
   public native function get objectEncoding() : uint;
   
   public native function set objectEncoding(param1:uint) : void;
   
   public native function get endian() : String;
   
   public native function set endian(param1:String) : void;
}
