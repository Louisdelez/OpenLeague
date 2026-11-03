package spark.effects
{
   import flash.utils.ByteArray;
   
   [DiscouragedForProfile("mobileDevice")]
   public class CrossFade extends AnimateTransitionShader
   {
      
      private static var CrossFadeShaderClass:Class = CrossFade_CrossFadeShaderClass;
      
      private static var crossFadeShaderCode:ByteArray = new CrossFadeShaderClass();
      
      public function CrossFade(target:Object = null)
      {
         super(target);
         shaderByteCode = crossFadeShaderCode;
      }
   }
}

