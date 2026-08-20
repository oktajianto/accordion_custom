/// A customizable, zero-dependency accordion for Flutter with single/multiple
/// expand modes, nested panels, a programmatic controller, keyboard navigation,
/// and full styling (colors, borders, radius, padding, icon).
///
/// See [AccordionCustom] for the main entry point.
library;

export 'src/accordion_content_style.dart' show AccordionContentStyle;
export 'src/accordion_header_style.dart'
    show AccordionHeaderStyle, AccordionIconPosition;
export 'src/custom_accordion.dart'
    show
        AccordionCustom,
        AccordionController,
        AccordionHeaderBuilder,
        AccordionItem,
        AccordionItemBuilder,
        AccordionMode;
