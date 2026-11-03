package blix.layout.vo
{
   public class Padding
   {
      
      public var left:Number;
      
      public var top:Number;
      
      public var right:Number;
      
      public var bottom:Number;
      
      public function Padding(... rest)
      {
         super();
         this.setPadding.apply(null,rest);
      }
      
      public function setPadding(... rest) : void
      {
         switch(rest.length)
         {
            case 4:
               this.top = rest[0];
               this.right = rest[1];
               this.bottom = rest[2];
               this.left = rest[3];
               break;
            case 3:
               this.top = rest[0];
               this.right = rest[1];
               this.bottom = rest[3];
               this.left = rest[1];
               break;
            case 2:
               this.top = rest[0];
               this.right = rest[1];
               this.bottom = rest[0];
               this.left = rest[1];
               break;
            case 1:
               this.top = rest[0];
               this.right = rest[0];
               this.bottom = rest[0];
               this.left = rest[0];
               break;
            default:
               this.top = 0;
               this.right = 0;
               this.bottom = 0;
               this.left = 0;
         }
      }
      
      public function equalTo(param1:Padding) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return this.left == param1.left && this.top == param1.top && this.right == param1.right && this.bottom == param1.bottom;
      }
      
      public function toString() : String
      {
         return "[Padding top=" + this.top + " right=" + this.right + " bottom=" + this.bottom + " left=" + this.left + "]";
      }
   }
}

