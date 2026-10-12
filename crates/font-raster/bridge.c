#include <ft2build.h>
#include FT_FREETYPE_H
#include <stdint.h>
#include <stddef.h>
#include <limits.h>
#include <string.h>
int ol_ft_library_new(void **out) {return FT_Init_FreeType((FT_Library*)out);}
void ol_ft_library_version(void *library,int32_t out[3]) {int a,b,c;FT_Library_Version((FT_Library)library,&a,&b,&c);out[0]=a;out[1]=b;out[2]=c;}
void ol_ft_library_done(void *library) {FT_Done_FreeType((FT_Library)library);}
int ol_ft_face_new(void *library,const uint8_t *data,size_t len,void **out) {
    if(len>LONG_MAX) return -1;
    return FT_New_Memory_Face((FT_Library)library,data,(FT_Long)len,0,(FT_Face*)out);
}
void ol_ft_face_done(void *face) {FT_Done_Face((FT_Face)face);}
int ol_ft_face_size(void *opaque,int32_t height,uint32_t x,uint32_t y,int32_t out[4]) {
    FT_Face face=(FT_Face)opaque;int error=FT_Set_Char_Size(face,0,height,x,y);if(error) return error;
    if(!face->size) return -1;
    out[0]=(int32_t)face->size->metrics.ascender;out[1]=(int32_t)face->size->metrics.descender;
    out[2]=(int32_t)face->size->metrics.height;out[3]=(int32_t)face->size->metrics.max_advance;return 0;
}
int ol_ft_face_metrics(void *opaque,int32_t out[4]) {
    FT_Face face=(FT_Face)opaque;if(!face->size) return -1;
    out[0]=(int32_t)face->size->metrics.ascender;out[1]=(int32_t)face->size->metrics.descender;
    out[2]=(int32_t)face->size->metrics.height;out[3]=(int32_t)face->size->metrics.max_advance;return 0;
}
int ol_ft_glyph_load(void *opaque,uint32_t character,int32_t flags,int32_t mode,int32_t out[7]) {
    FT_Face face=(FT_Face)opaque;FT_UInt index=FT_Get_Char_Index(face,character);int error;
    if(!index) return -2;
    error=FT_Load_Glyph(face,index,flags);if(error) return error;
    error=FT_Render_Glyph(face->glyph,(FT_Render_Mode)mode);if(error) return error;
    if(face->glyph->bitmap.pixel_mode!=FT_PIXEL_MODE_GRAY) return -3;
    if(face->glyph->bitmap.width>INT32_MAX || face->glyph->bitmap.rows>INT32_MAX) return -4;
    out[0]=(int32_t)index;out[1]=(int32_t)face->glyph->bitmap.width;out[2]=(int32_t)face->glyph->bitmap.rows;
    out[3]=face->glyph->bitmap_left;out[4]=face->glyph->bitmap_top;out[5]=(int32_t)face->glyph->advance.x;out[6]=(int32_t)face->glyph->advance.y;return 0;
}
int ol_ft_glyph_copy(void *opaque,uint8_t *out,size_t len) {
    FT_Bitmap *bitmap=&((FT_Face)opaque)->glyph->bitmap;size_t width=bitmap->width,rows=bitmap->rows,row;
    if(rows && width>SIZE_MAX/rows) return -4;
    if(len!=width*rows) return -4;
    if(!len) return 0;
    if(bitmap->pixel_mode!=FT_PIXEL_MODE_GRAY || (size_t)(bitmap->pitch<0?-(int64_t)bitmap->pitch:bitmap->pitch)<width || !bitmap->buffer) return -3;
    for(row=0;row<rows;row++) memcpy(out+row*width,bitmap->buffer+(ptrdiff_t)row*bitmap->pitch,width);
    return 0;
}

/* Original glyph constructor: UTF16 code unit, flags0 and signed26.6 metrics. */
int ol_ft_native_metrics(void *opaque,uint16_t character,int32_t out[7]) {
    FT_Face face=(FT_Face)opaque;FT_UInt index=FT_Get_Char_Index(face,character);
    int error=FT_Load_Glyph(face,index,0);if(error) return error;
    if(!face->size || !face->glyph) return -1;
    out[0]=(int32_t)index;out[1]=(int32_t)face->glyph->advance.x;
    out[2]=(int32_t)face->glyph->metrics.horiBearingX;out[3]=(int32_t)face->glyph->metrics.width;
    out[4]=(int32_t)face->glyph->metrics.horiBearingY;out[5]=(int32_t)face->glyph->metrics.height;
    out[6]=(int32_t)face->size->metrics.ascender;return 0;
}
/* Original bitmap path uses FT_LOAD_RENDER4; do not render a second time. */
int ol_ft_native_bitmap(void *opaque,uint32_t index,int32_t out[4]) {
    FT_Face face=(FT_Face)opaque;int error=FT_Load_Glyph(face,index,4);if(error) return error;
    if(!face->size || !face->glyph || face->glyph->format!=FT_GLYPH_FORMAT_BITMAP) return -3;
    if(face->glyph->bitmap.width>INT32_MAX || face->glyph->bitmap.rows>INT32_MAX) return -4;
    if(face->glyph->bitmap.width && face->glyph->bitmap.rows && face->glyph->bitmap.pixel_mode!=FT_PIXEL_MODE_GRAY) return -3;
    out[0]=(int32_t)face->glyph->bitmap.width;out[1]=(int32_t)face->glyph->bitmap.rows;
    out[2]=(int32_t)face->glyph->metrics.horiBearingY;out[3]=(int32_t)face->size->metrics.ascender;return 0;
}

int ol_ft_native_kerning(void *opaque,uint32_t left,uint32_t right,int32_t *out) {
    FT_Vector delta;int error=FT_Get_Kerning((FT_Face)opaque,left,right,0,&delta);if(error) return error;
    *out=(int32_t)delta.x;return 0;
}
