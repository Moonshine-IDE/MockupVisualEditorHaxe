package theme;

import feathers.themes.ClassVariantTheme;

extern class AppTheme extends ClassVariantTheme 
{
    public static final THEME_VARIANT_BUTTON_SECTION:String;
    public static final THEME_VARIANT_SECTION_TITLE:String;
    public static final THEME_VARIANT_LINE:String;
    public static final THEME_NORMAL_BACKGROUND_SKIN:String;
    public static final DEFAULT_FONT:String;
    public static final THEME_BG_NORMAL:UInt;
	public static final THEME_BG_DARK:UInt;

    public static function isDarkMode():Bool;
}