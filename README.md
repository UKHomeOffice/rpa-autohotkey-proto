# [RPA](https://en.wikipedia.org/wiki/Robotic_process_automation) proof of concept w/ autokey

Point of this POC is to explore if it's possible to leverage opensource tech including:
 - [autohotkey](https://www.autohotkey.com)
 - [packer](https://packer.io)
 - [terraform](https://terraform.io)

With some aws gubbins to stick it all together to provide an unsupervised RPA equivalent whereby jobs can be created, undergo peer review etc, executed affordably (on spot instances) and results persisted back.

## TODO

 - [x] build windows ami with autohotkey installed
   - [ ] on boot pull down autohotkey script from metadata api
   - [x] execute autohotkey script
   - [x] publish autohotkey result to s3 bucket
   - [x] shutdown
 - [ ] Kube job template to execute

