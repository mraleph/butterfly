library html;

class Node {
  final List<Node> children = <Node>[];

  Node findMatching(matcher) {
    if (matcher(this)) {
      return this;
    }

    for (var child in children) {
      final result = child.findMatching(matcher);
      if (result != null) {
        return result;
      }
    }

    return null;
  }
}

class Text extends Node {
  String text;

  Text(this.text);

  toString() => text;
}

class Event {
  final Element target;

  Event(this.target);
}

typedef void EventCallback(Event e);

class StyleSet {
  final Map<String, String> _properties = <String, String>{};

  void setProperty(String key, String value) {
    _properties[key] = value;
  }

  void removeProperty(String key) {
    _properties.remove(key);
  }
}

class ClassesSet {

}

class Element extends Node {
  final String _tag;
  final Map<String, String> attributes = <String, String>{};
  final Map<String, EventCallback> listeners = <String, EventCallback>{};
  final StyleSet style = new StyleSet();
  final ClassesSet classes = new ClassesSet();

  Element.tag(this._tag);

  void dispatch(String event, Event ev) {
    listeners[event]?.call(ev);
  }

  String getAttribute(String key) => attributes[key];

  void setAttribute(String key, String value) {
    attributes[key] = value;
  }

  set text (String value) {
    children.length = 0;
    children.add(new Text(value));
  }

  void append(Element el) {
    children.add(el);
  }

  void addEventListener(String event, EventCallback f) {
    listeners[event] = f;
  }

  String toString() {
    final List<String> attrs = <String>[];

    attributes.forEach((key, value) {
      attrs.add('${key}="${value}"');
    });

    if (children.isEmpty) {
      return '<${_tag}${attrs.isNotEmpty ? ' ' : ''}${attrs.join(' ')}/>';
    } else {
      return '<${_tag}${attrs.isNotEmpty ? ' ' : ''}${attrs.join(' ')}>${children.join('')}</${_tag}>';
    }
  }
}

class DivElement extends Element {
  DivElement() : super.tag('div');
}

class DocumentElement extends Element {
  Element get head => null;

  DocumentElement() : super.tag("document");
}

final elementsById = { "app-host": new Element.tag('div') };

Element querySelector(String selector) {
  if (selector.startsWith('#'))
    return elementsById[selector.substring(1)];
  else
    return null;
}

final document = new DocumentElement();
