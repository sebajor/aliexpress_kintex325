Simple project with a microblaze and some memories. This is just to check
how to elaborate vivado ips to the workflow.

The only note is that if you use generated vivado ip you have to
comment the directive `deafult_nettype because the vivado's ip
declare the input outputs types inside the code.
