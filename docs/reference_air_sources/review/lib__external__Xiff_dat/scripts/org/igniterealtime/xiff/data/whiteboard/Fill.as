package org.igniterealtime.xiff.data.whiteboard
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class Fill implements ISerializable
   {
      
      private var myColor:Number;
      
      private var myOpacity:Number;
      
      public function Fill()
      {
         super();
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(Boolean(this.myColor))
         {
            param1.attributes["fill"] = "#" + this.myColor.toString(16);
         }
         if(Boolean(this.myOpacity))
         {
            param1.attributes["fill-opacity"] = this.myOpacity.toString();
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         if(Boolean(param1.attributes["fill"]))
         {
            this.myColor = new Number("0x" + param1.attributes["fill"].slice(1));
         }
         if(Boolean(param1.attributes["fill-opacity"]))
         {
            this.myOpacity = new Number(param1.attributes["fill-opacity"]);
         }
         return true;
      }
      
      public function get color() : Number
      {
         return Boolean(this.myColor) ? this.myColor : 0;
      }
      
      public function set color(param1:Number) : void
      {
         this.myColor = param1;
      }
      
      public function get opacity() : Number
      {
         return Boolean(this.myOpacity) ? this.myOpacity : 100;
      }
      
      public function set opacity(param1:Number) : void
      {
         this.myOpacity = param1;
      }
   }
}

