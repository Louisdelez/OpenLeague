package spark.effects
{
   import flash.utils.ByteArray;
   import mx.effects.IEffectInstance;
   
   [DiscouragedForProfile("mobileDevice")]
   public class Wipe extends AnimateTransitionShader
   {
      
      private static var WipeUpShaderClass:Class = Wipe_WipeUpShaderClass;
      
      private static var wipeUpShaderCode:ByteArray = new WipeUpShaderClass();
      
      private static var WipeDownShaderClass:Class = Wipe_WipeDownShaderClass;
      
      private static var wipeDownShaderCode:ByteArray = new WipeDownShaderClass();
      
      private static var WipeRightShaderClass:Class = Wipe_WipeRightShaderClass;
      
      private static var wipeRightShaderCode:ByteArray = new WipeRightShaderClass();
      
      private static var WipeLeftShaderClass:Class = Wipe_WipeLeftShaderClass;
      
      private static var wipeLeftShaderCode:ByteArray = new WipeLeftShaderClass();
      
      [Inspectable(enumeration="left,right,up,down",defaultValue="right")]
      public var direction:String = "right";
      
      public function Wipe(target:Object = null)
      {
         super(target);
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         switch(this.direction)
         {
            case WipeDirection.RIGHT:
               shaderByteCode = wipeRightShaderCode;
               break;
            case WipeDirection.LEFT:
               shaderByteCode = wipeLeftShaderCode;
               break;
            case WipeDirection.UP:
               shaderByteCode = wipeUpShaderCode;
               break;
            case WipeDirection.DOWN:
               shaderByteCode = wipeDownShaderCode;
         }
         super.initInstance(instance);
      }
   }
}

