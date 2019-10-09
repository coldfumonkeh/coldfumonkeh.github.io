---
title: Events
layout: default
---

<section class="text-center height-50">
    <div class="container pos-vertical-center">
        <div class="row">
            <div class="col-md-8 col-lg-6">
                <h1>Presentations and Events</h1>
                <p class="lead">
                    Matt Gifford has presented at the following events and conferences
                </p>
            </div>
        </div>
        <!--end of row-->
    </div>
    <!--end of container-->
</section>

<section>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="process-1">
                    {% for event in site.events reversed %}
                        <div class="process__item">
                            <h4>{{ event.title }}</h4>
                            <h5>{{ event.meta.event_date }}</h5>
                            <p>{{ event.meta.event_location }}{% if event.meta.event_country != '' %}, {{ event.meta.event_country }}{% endif %}</p>
                        </div>
                    {% endfor %}
                </div>
                <!--end process-->
            </div>
        </div>
        <!--end of row-->
    </div>
    <!--end of container-->
</section>