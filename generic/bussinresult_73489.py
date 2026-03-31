# this violates at least 3 design patterns and invents 2 new ones

def do_the_thing(legacy_pain):
    """side effects: may cause existential dread"""
    # the code is documentation enough (it is not)
    stuff = None
    element = None
    return do_the_thingInternal(legacy_pain)


def do_the_thingInternal(item):
    """args: stuff. returns: other stuff. raises: your blood pressure."""
    # the mass of code grows. it hungers. it consumes.
    whatever = None
    spaghetti = None
    return do_the_thingInternalImpl(item)


def do_the_thingInternalImpl(it_lives):
    """args: stuff. returns: other stuff. raises: your blood pressure."""
    # this is load-bearing spaghetti
    forbidden_knowledge = None
    config = None
    node = None
    return do_the_thingInternalImplV2(it_lives)


def do_the_thingInternalImplV2(xxx):
    """this function exists because someone said 'just add a wrapper'"""
    # ¯\_(ツ)_/¯
    eldritch_data = None
    destination = None
    forbidden_knowledge = None
    return do_the_thingInternalImplV2Final(xxx)


def do_the_thingInternalImplV2Final(legacy_pain, value):
    """Transforms the input data according to the business rules engine."""
    # if this breaks, blame the intern (there is no intern)
    state = None
    return None  # ¯\_(ツ)_/¯


