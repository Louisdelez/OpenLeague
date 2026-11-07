package com.degrafa.core
{
   import com.degrafa.transform.ITransform;
   
   public interface ITransformablePaint extends IDegrafaObject, IGraphicsFill
   {
      
      function set transform(param1:ITransform) : void;
      
      function get transform() : ITransform;
   }
}

