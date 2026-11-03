package org.swizframework.reflection
{
   public class BaseMetadataTag implements IMetadataTag
   {
      
      protected var _name:String;
      
      protected var _args:Array;
      
      protected var _host:IMetadataHost;
      
      protected var _defaultArgName:String;
      
      public function BaseMetadataTag()
      {
         super();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      [ArrayElementType("org.swizframework.reflection.MetadataArg")]
      public function get args() : Array
      {
         return this._args;
      }
      
      public function set args(value:Array) : void
      {
         this._args = value;
      }
      
      public function get host() : IMetadataHost
      {
         return this._host;
      }
      
      public function set host(value:IMetadataHost) : void
      {
         this._host = value;
      }
      
      public function get defaultArgName() : String
      {
         return this._defaultArgName;
      }
      
      public function set defaultArgName(value:String) : void
      {
         this._defaultArgName = value;
      }
      
      public function get asTag() : String
      {
         return this.toString();
      }
      
      public function hasArg(argName:String) : Boolean
      {
         var arg:MetadataArg = null;
         for each(arg in this.args)
         {
            if(arg.key == argName || arg.key == "" && argName == this.defaultArgName)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getArg(argName:String) : MetadataArg
      {
         var arg:MetadataArg = null;
         for each(arg in this.args)
         {
            if(arg.key == argName || arg.key == "" && argName == this.defaultArgName)
            {
               return arg;
            }
         }
         return null;
      }
      
      public function copyFrom(metadataTag:IMetadataTag) : void
      {
         this.name = metadataTag.name;
         this.args = metadataTag.args;
         this.host = metadataTag.host;
      }
      
      public function toString() : String
      {
         var i:int = 0;
         var arg:MetadataArg = null;
         var str:String = "[" + this.name;
         if(this.args != null && this.args.length > 0)
         {
            str += "( ";
            for(i = 0; i < this.args.length; i++)
            {
               arg = this.args[i];
               if(arg.key != "")
               {
                  str += arg.key + "=";
               }
               str += "\"" + arg.value + "\"";
               if(i + 1 < this.args.length)
               {
                  str += ", ";
               }
            }
            str += " )";
         }
         return str + "]";
      }
   }
}

