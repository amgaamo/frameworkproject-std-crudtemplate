# Copyright © Netbay.co.th
# ROBOT For Test

FROM mobydick.netbay.co.th/qa/standard-robot/rf5std-browserlib:latest
RUN ["mkdir","/PROJECT-STD"]
WORKDIR "/PROJECT-STD"

ADD ./__helpcheck ./__helpcheck
ADD ./testsuite ./testsuite
ADD ./pageobjects ./pageobjects
ADD ./resources ./resources
ADD ./output ./output
ADD ./listener_email ./listener_email