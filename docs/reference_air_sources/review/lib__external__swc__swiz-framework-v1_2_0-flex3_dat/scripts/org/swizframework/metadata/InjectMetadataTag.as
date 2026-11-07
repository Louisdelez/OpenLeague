package org.swizframework.metadata
{
   import org.swizframework.reflection.BaseMetadataTag;
   import org.swizframework.reflection.IMetadataTag;
   import org.swizframework.utils.logging.SwizLogger;
   
   public class InjectMetadataTag extends BaseMetadataTag
   {
      
      protected var logger:SwizLogger = SwizLogger.getLogger(this);
      
      protected var _source:String;
      
      protected var _destination:String;
      
      protected var _twoWay:Boolean = false;
      
      protected var _bind:Boolean = false;
      
      protected var _required:Boolean = true;
      
      public function InjectMetadataTag()
      {
         super();
         defaultArgName = "source";
      }
      
      public function get source() : String
      {
         return this._source;
      }
      
      public function set source(value:String) : void
      {
         this._source = value;
      }
      
      public function get destination() : String
      {
         return this._destination;
      }
      
      public function get twoWay() : Boolean
      {
         return this._twoWay;
      }
      
      public function get bind() : Boolean
      {
         return this._bind;
      }
      
      public function get required() : Boolean
      {
         return this._required;
      }
      
      override public function copyFrom(metadataTag:IMetadataTag) : void
      {
         super.copyFrom(metadataTag);
         if(hasArg("bean") && hasArg("source"))
         {
            throw new Error("Your metadata tag defines both a bean and source attribute. source has replaced bean, please update accordingly.");
         }
         if(hasArg("bean"))
         {
            this.logger.warn("The bean attribute has been deprecated in favor of the source attribute. Please update your code accordingly. Found in {0}",metadataTag.asTag);
            this._source = getArg("bean").value;
         }
         if(hasArg("source"))
         {
            this._source = getArg("source").value;
         }
         if(hasArg("property"))
         {
            this.logger.warn("The property attribute has been deprecated. Please use dot notation in your source attribute instead. Found in {0}",metadataTag.asTag);
            this._source += "." + getArg("property").value;
         }
         if(hasArg("destination"))
         {
            this._destination = getArg("destination").value;
         }
         if(hasArg("twoWay"))
         {
            this._twoWay = getArg("twoWay").value == "true";
         }
         if(hasArg("bind"))
         {
            this._bind = getArg("bind").value == "true";
         }
         if(hasArg("required"))
         {
            this._required = getArg("required").value == "true";
         }
      }
   }
}

