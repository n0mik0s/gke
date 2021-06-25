/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
variable "cluster_name" {
  description = "Cluster name. Required if using existing KSA."
  type        = string
  default     = ""
}

variable "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster). Required if using existing KSA."
  type        = string
  default     = ""
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "automount_service_account_token" {
  description = "Enable automatic mounting of the service account token"
  default     = false
  type        = bool
}

variable "wi_set" {
  type = set(map(string))
  default = [{
    name                = null
    namespace           = null
    roles               = null
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  }]
  description = "The set of objects with all variables that should be set for WI processing"
}