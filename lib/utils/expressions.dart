final regularExpression =
    RegExp(r'^[a-zA-Z0-9_\-@,.ãàâÀêëéÉèÈíîÍôóÓûúüÚçÇñÑ@ \.;]+$');

final phoneExpression = RegExp(r'^[0-9_\-+() \.,;]+$');
final alphanumeric = RegExp(r'^[a-zA-Z0-9.:#_-éàô ]+$');
final numeroExpression =
    RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
