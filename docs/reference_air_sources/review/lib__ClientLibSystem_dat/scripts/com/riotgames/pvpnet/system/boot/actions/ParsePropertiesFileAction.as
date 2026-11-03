package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import blix.action.FileStreamAction;
   import blix.action.IAction;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   import com.riotgames.util.logging.getLogger;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import mx.logging.ILogger;
   import mx.utils.StringUtil;
   
   public class ParsePropertiesFileAction extends BasicAction
   {
      
      private var _configObjects:Array;
      
      private var _propertiesFile:File;
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var logger:ILogger;
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var fileStreamAction:FileStreamAction = new FileStreamAction();
      
      public function ParsePropertiesFileAction(param1:File, param2:Array)
      {
         super(false);
         this._propertiesFile = param1;
         this._configObjects = param2;
         this.logger = getLogger(this);
      }
      
      override protected function doInvocation() : void
      {
         this.loadPropertiesFile();
      }
      
      private function loadPropertiesFile() : void
      {
         if(this._propertiesFile.exists)
         {
            this.fileStreamAction.file = this._propertiesFile;
            this.fileStreamAction.unmarshallDataFunction = this.unmarshallProperties;
            this.fileStreamAction.getCompleted().add(this.applyProperties);
            this.fileStreamAction.getErred().add(this.defaultErredHandler);
            this.fileStreamAction.invoke();
         }
         else
         {
            complete();
         }
      }
      
      private function unmarshallProperties(param1:ByteArray) : Vector.<SimpleProperty>
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:SimpleProperty = null;
         var _loc2_:String = param1.readUTFBytes(param1.bytesAvailable);
         var _loc3_:Vector.<String> = Vector.<String>(_loc2_.split(File.lineEnding));
         var _loc4_:Vector.<SimpleProperty> = new Vector.<SimpleProperty>();
         var _loc5_:uint = 1;
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_.charAt(0) != "#")
            {
               if(StringUtil.trim(_loc6_).length != 0)
               {
                  _loc7_ = [_loc6_.substring(0,_loc6_.indexOf("=",1)),_loc6_.substring(_loc6_.indexOf("=",1) + 1)];
                  if(_loc7_[0] != "")
                  {
                     _loc8_ = StringUtil.trim(_loc7_[0]);
                     _loc9_ = StringUtil.trim(_loc7_[1]);
                     _loc10_ = new SimpleProperty(_loc8_,_loc9_);
                     _loc4_.push(_loc10_);
                     _loc5_++;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private function applyProperties(param1:FileStreamAction) : void
      {
         var _loc3_:SimpleProperty = null;
         var _loc4_:Object = null;
         var _loc5_:MultiValueProperty = null;
         var _loc2_:Vector.<SimpleProperty> = param1.unmarshalledData;
         for each(_loc3_ in _loc2_)
         {
            for each(_loc4_ in this._configObjects)
            {
               if(_loc4_.hasOwnProperty(_loc3_.key))
               {
                  if(_loc4_[_loc3_.key] is MultiValueProperty)
                  {
                     _loc5_ = _loc4_[_loc3_.key] as MultiValueProperty;
                     _loc5_.parsePropertyString(_loc3_.value);
                  }
                  else if(_loc3_.secondaryKey == null)
                  {
                     _loc4_[_loc3_.key] = this.parseValue(_loc3_.value);
                  }
                  else
                  {
                     _loc4_[_loc3_.key][_loc3_.secondaryKey] = this.parseValue(_loc3_.value);
                  }
               }
            }
         }
         complete();
      }
      
      private function parseValue(param1:String) : *
      {
         switch(param1.toLowerCase())
         {
            case "true":
               return true;
            case "false":
               return false;
            default:
               return param1;
         }
      }
      
      private function defaultErredHandler(param1:IAction) : void
      {
         complete();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.fileStreamAction.getCompleted().remove(this.applyProperties);
         this.fileStreamAction.getErred().remove(this.defaultErredHandler);
      }
      
      override protected function onCompleted() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._configObjects)
         {
            if(_loc1_.hasOwnProperty("propertiesHaveLoaded") && _loc1_["propertiesHaveLoaded"] is Function)
            {
               _loc1_["propertiesHaveLoaded"]();
            }
         }
      }
   }
}

class SimpleProperty
{
   
   public var key:String;
   
   public var secondaryKey:String;
   
   public var value:String;
   
   public function SimpleProperty(param1:String, param2:String)
   {
      super();
      this.key = param1;
      this.value = param2;
      var _loc3_:int = param1.indexOf(".");
      if(param1 != null && _loc3_ >= 0 && _loc3_ + 1 < param1.length)
      {
         this.key = param1.substring(0,_loc3_);
         this.secondaryKey = param1.substring(_loc3_ + 1);
      }
   }
}
