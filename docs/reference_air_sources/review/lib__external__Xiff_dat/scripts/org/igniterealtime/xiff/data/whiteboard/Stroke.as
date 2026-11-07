package org.igniterealtime.xiff.data.whiteboard
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class Stroke implements ISerializable
   {
      
      private var myColor:Number;
      
      private var myWidth:Number;
      
      private var myOpacity:Number;
      
      public function Stroke()
      {
         super();
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(Boolean(this.myColor))
         {
            param1.attributes["stroke"] = "#" + this.myColor.toString(16);
         }
         if(Boolean(this.myWidth))
         {
            param1.attributes["stroke-width"] = this.myWidth.toString();
         }
         if(Boolean(this.myOpacity))
         {
            param1.attributes["stroke-opacity"] = this.myOpacity.toString();
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         if(Boolean(param1.attributes["stroke"]))
         {
            this.myColor = new Number("0x" + param1.attributes["stroke"].slice(1));
         }
         if(Boolean(param1.attributes["stroke-width"]))
         {
            this.myWidth = new Number(param1.attributes["stroke-width"]);
         }
         if(Boolean(param1.attributes["stroke-opacity"]))
         {
            this.myOpacity = new Number(param1.attributes["stroke-opacity"]);
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
      
      public function get width() : Number
      {
         return Boolean(this.myWidth) ? this.myWidth : 1;
      }
      
      public function set width(param1:Number) : void
      {
         this.myWidth = param1;
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

